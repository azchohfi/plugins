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

const String kMenuChannel = 'flutter/menubar';

const String _kMenuSetMethod = 'Menubar.SetMenu';
class MenubarMethodChannel {
  MenubarMethodChannel() : _channel = const MethodChannel(kMenuChannel);
  MethodChannel _channel;

  Future<void> setMenu(List<dynamic> menus) async {
  //   try {
  //     _updateInProgress = true;
  //     await _platformChannel.invokeMethod(
  //         _kMenuSetMethod, _channelRepresentationForMenus(menus));
  //     _updateInProgress = false;
  //   } on PlatformException catch (e) {
  //     print('Platform exception setting menu: ${e.message}');
  //   }
  // }
}