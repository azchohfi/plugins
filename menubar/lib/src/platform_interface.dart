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
import 'dart:core';

import 'package:flutter/widgets.dart';

import 'menu_item.dart';
import 'menubar_method_channel.dart';

abstract class MenubarPlatform {
  MenubarPlatform() : _menubarChannel = MenubarMethodChannel();

  MenubarMethodChannel _menubarChannel;

  Future<void> setMenu(List<Submenu> menus) async {
    final List<dynamic> representedMenu = platformMenuRepresentation(menus);
    _menubarChannel.setMenu(representedMenu);
  }

  List<dynamic> platformMenuRepresentation(List<AbstractMenuItem> item) {
    throw UnimplementedError('platformMenuRepresentation has not been implemented by the current platform');
  }

  Map<String, dynamic> platformSubmenuRepresentation(AbstractMenuItem item) {
    throw UnimplementedError('platformSubmenuRepresentation has not been implemented by the current platform');
  }

  void platformShortcutRepresentation(LogicalKeySet shortcut, Map<String, dynamic> platformRepresentation) {
    throw UnimplementedError('PlatformShortcutRepresentation has not been implemented by the current platform');
  }
}