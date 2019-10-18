// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'menu_item.dart';
import 'platform_interface.dart';

// Keys for the map representations of menus sent to kMenuSetMethod.

/// The ID of the menu item, as an integer. If present, this indicates that the
/// menu item should trigger a kMenuItemSelectedCallbackMethod call when
/// selected.
const String _kIdKey = 'id';

/// The label that should be displayed for the menu, as a string.
const String _kLabelKey = 'label';

/// The string corresponding to the shortcut key equivalent without modifiers.
///
/// When menu support moves into Flutter itself, this will likely use keyId.
/// That's not useable for this plugin-based prototype however, since keyId is
/// not stable.
const String _kShortcutKeyEquivalent = 'keyEquivalent';

/// An alternative to _kShortcutKeyEquivalent for keys that have no string
/// equivalent. Only this or _kShortcutKeyEquivalent should be specified.
///
/// This is a partial workaround for the lack of keyId discussed above, to
/// handle common shortcut keys that _kShortcutKeyEquivalent can't represent.
///
/// See _ShortcutSpecialKeys for possible values.
const String _kShortcutSpecialKey = 'specialKey';

/// The modifier flags to apply to the shortcut key.
///
/// The value is an int representing a flag set; see below for possible values.
const String _kShortcutKeyModifiers = 'keyModifiers';

/// Whether or not the menu item should be enabled, as a boolean. If not present
/// the defualt is to enabled the item.
const String _kEnabledKey = 'enabled';

/// Menu items that should be shown as a submenu of this item, as an array.
const String _kChildrenKey = 'children';

/// Whether or not the menu item is a divider, as a boolean. If true, no other
/// keys will be present.
const String _kDividerKey = 'isDivider';

// Values for _kShortcutKeyModifiers.
const int _shortcutModifierMeta = 1 << 0;
const int _shortcutModifierShift = 1 << 1;
const int _shortcutModifierAlt = 1 << 2;
const int _shortcutModifierControl = 1 << 3;

/// Values for _kShortcutSpecialKey.
final Map<LogicalKeyboardKey, int> _shortcutSpecialKeyValues = <LogicalKeyboardKey, int>{
  LogicalKeyboardKey.f1: 1,
  LogicalKeyboardKey.f2: 2,
  LogicalKeyboardKey.f3: 3,
  LogicalKeyboardKey.f4: 4,
  LogicalKeyboardKey.f5: 5,
  LogicalKeyboardKey.f6: 6,
  LogicalKeyboardKey.f7: 7,
  LogicalKeyboardKey.f8: 8,
  LogicalKeyboardKey.f9: 9,
  LogicalKeyboardKey.f10: 10,
  LogicalKeyboardKey.f11: 11,
  LogicalKeyboardKey.f12: 12,
  LogicalKeyboardKey.backspace: 13,
  LogicalKeyboardKey.delete: 14,
};


class MenubarMacos extends MenubarPlatform {

  /// Map from unique identifiers assigned by this class to the callbacks for
  /// those menu items.
  final Map<int, MenuSelectedCallback> _selectionCallbacks = <int,MenuSelectedCallback>{};

  /// The ID to use the next time a menu item needs an ID assigned.
  int _nextMenuItemId = 1;

  /// Whether or not a call to [_kMenuSetMethod] is outstanding.
  ///
  /// This is used to drop any menu callbacks that aren't received until
  /// after a new call to setMenu, so that clients don't received unexpected
  /// stale callbacks.
  bool _updateInProgress;

  @override 
  List<dynamic> platformMenuRepresentation(List<AbstractMenuItem> items) {
    return items.map(platformSubmenuRepresentation).toList();  
  }

  @override
  Map<String, dynamic> platformSubmenuRepresentation(AbstractMenuItem item) {
    final Map<String, dynamic>representation = <String, dynamic>{};
    if (item is MenuDivider) {
      representation[_kDividerKey] = true;
    } else {
      representation[_kLabelKey] = item.label;
      if (item is Submenu) {
        representation[_kChildrenKey] =
            platformMenuRepresentation(item.children);
      } else if (item is MenuItem) {
        if (item.onClicked != null) {
          representation[_kIdKey] = _storeMenuCallback(item.onClicked);
        }
        if (!item.enabled) {
          representation[_kEnabledKey] = false;
        }
        if (item.shortcut != null) {
          _addShortcutToRepresentation(item.shortcut, representation);
        }
      } else {
        throw ArgumentError(
            'Unknown AbstractMenuItem type: $item (${item.runtimeType})');
      }
    }
    return representation;
  }

  @override  
  void platformShortcutRepresentation(LogicalKeySet shortcut, Map<String, dynamic> platformRepresentation) {
    bool hasNonModifierKey = false;
    int modifiers = 0;
    for (final LogicalKeyboardKey key in shortcut.keys) {
      if (key == LogicalKeyboardKey.meta) {
        modifiers |= _shortcutModifierMeta;
      } else if (key == LogicalKeyboardKey.shift) {
        modifiers |= _shortcutModifierShift;
      } else if (key == LogicalKeyboardKey.alt) {
        modifiers |= _shortcutModifierAlt;
      } else if (key == LogicalKeyboardKey.control) {
        modifiers |= _shortcutModifierControl;
      } else {
        if (hasNonModifierKey) {
          throw ArgumentError('Invalid menu item shortcut: $shortcut\n'
              'Menu items must have exactly one non-modifier key.');
        }

        if (key.keyLabel != null) {
          platformRepresentation[_kShortcutKeyEquivalent] = key.keyLabel;
        } else {
          final int specialKey = _shortcutSpecialKeyValues[key];
          if (specialKey == null) {
            throw ArgumentError('Unsupported menu shortcut key: $key\n'
                'Please add this key to the special key mapping.');
          }
          platformRepresentation[_kShortcutSpecialKey] = specialKey;
        }
        hasNonModifierKey = true;
      }
    }

    if (!hasNonModifierKey) {
      throw ArgumentError('Invalid menu item shortcut: $shortcut\n'
          'Menu items must have exactly one non-modifier key.');
    }
    platformRepresentation[_kShortcutKeyModifiers] = modifiers;
  }


  /// Stores [callback] for use plugin callback handling, returning the ID
  /// under which it was stored.
  ///
  /// The returned ID should be attached to the menu so that the native plugin
  /// can identify the menu item selected in the callback.
  int _storeMenuCallback(MenuSelectedCallback callback) {
    final int id = _nextMenuItemId++;
    _selectionCallbacks[id] = callback;
    return id;
  }

}