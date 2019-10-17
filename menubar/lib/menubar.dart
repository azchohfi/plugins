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
import 'dart:async';

import 'src/menu_item.dart';
import 'src/menubar_macos.dart';
import 'src/platform_interface.dart';

class Menubar {

  // TODO: Make this conditional to more plaforms once available.
  MenubarPlatform _platform = MenubarMacos();

  Future<void> setMenu(List<Submenu> menus) async {
    _platform.setMenu(menus);
  }
}
