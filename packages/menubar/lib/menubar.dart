import 'dart:async';

import 'package:flutter/services.dart';

class Menubar {
  static const MethodChannel _channel =
      const MethodChannel('menubar');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
