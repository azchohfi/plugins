// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show required;

import 'path_provider_platform_interface.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.io/path_provider');

/// An implementation of [PathProviderPlatform] that uses method channels.
class MethodChannelUrlLauncher extends PathProviderPlatform {
  @override
  Future<Directory> getTemporaryDirectory() async {
    final String path =
      await _channel.invokeMethod<String>('getTemporaryDirectory'); 
    if (path == null) {
      return null;
    }
    
    return Directory(path);
  }

  @override
  Future<Directory> getApplicationSupportDirectory() async {
    final String path =
        await _channel.invokeMethod<String>('getApplicationSupportDirectory');
    if (path == null) {
      return null;
    }

    return Directory(path);
  }

  @override
  Future<Directory> getLibraryDirectory() async {
    if (_platform.isAndroid) {
      throw UnsupportedError('Functionality not available on Android');
    }
    final String path =
        await _channel.invokeMethod<String>('getLibraryDirectory');
    if (path == null) {
      return null;
    }
    return Directory(path);
  }

  @override
  Future<Directory> getApplicationDocumentsDirectory() async {
    final String path =
        await _channel.invokeMethod<String>('getApplicationDocumentsDirectory');
    if (path == null) {
      return null;
    }
    return Directory(path);
  }

  Future<Directory> getExternalStorageDirectory() async {
    if (_platform.isIOS) {
      throw UnsupportedError('Functionality not available on iOS');
    }
    final String path =
        await _channel.invokeMethod<String>('getStorageDirectory');
    if (path == null) {
      return null;
    }
    return Directory(path);
  }

  Future<List<Directory>> getExternalCacheDirectories() async {
    if (_platform.isIOS) {
      throw UnsupportedError('Functionality not available on iOS');
    }
    final List<String> paths =
        await _channel.invokeListMethod<String>('getExternalCacheDirectories');

    return paths.map((String path) => Directory(path)).toList();
  }


//TODO: remove this
/// Corresponds to constants defined in Androids `android.os.Environment` class.
///
/// https://developer.android.com/reference/android/os/Environment.html#fields_1
enum StorageDirectory {
  /// Contains audio files that should be treated as music.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_MUSIC.
  music,

  /// Contains audio files that should be treated as podcasts.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_PODCASTS.
  podcasts,

  /// Contains audio files that should be treated as ringtones.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_RINGTONES.
  ringtones,

  /// Contains audio files that should be treated as alarm sounds.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_ALARMS.
  alarms,

  /// Contains audio files that should be treated as notification sounds.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_NOTIFICATIONS.
  notifications,

  /// Contains images. See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_PICTURES.
  pictures,

  /// Contains movies. See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_MOVIES.
  movies,

  /// Contains files of any type that have been downloaded by the user.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_DOWNLOADS.
  downloads,

  /// Used to hold both pictures and videos when the device filesystem is
  /// treated like a camera's.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_DCIM.
  dcim,

  /// Holds user-created documents. See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_DOCUMENTS.
  documents,
}

  Future<List<Directory>> getExternalStorageDirectories({
    /// Optional parameter. See [StorageDirectory] for more informations on
    /// how this type translates to Android storage directories.
    StorageDirectory type,
  }) async {
    if (!_platform.isAndroid) {
      throw UnsupportedError('Functionality only availble on Android');
    }
    final List<String> paths = await _channel.invokeListMethod<String>(
      'getExternalStorageDirectories',
      <String, dynamic>{'type': type?.index},
    );

    return paths.map((String path) => Directory(path)).toList();
  }

}
