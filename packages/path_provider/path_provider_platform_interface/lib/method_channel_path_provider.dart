// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show required;

import 'path_provider_platform_interface.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.io/path_provider');

/// An implementation of [UrlLauncherPlatform] that uses method channels.
class MethodChannelUrlLauncher extends UrlLauncherPlatform {}
