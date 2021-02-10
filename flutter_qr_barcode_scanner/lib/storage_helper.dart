

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Classes.dart';

class StorageHelper {

  static const String KEY = "IMAGE_KEY";

  static Future<String> getFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY) ?? null;
  }

  static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY, value);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static String encode(List<DirectoryOS> saved_image) => json.encode(
    saved_image
        .map<Map<String, dynamic>>((saved_image) => DirectoryOS.toMap(saved_image))
        .toList(),
  );

  static List<DirectoryOS> decode(String saved_images) =>
      (json.decode(saved_images) as List<dynamic>)
          .map<DirectoryOS>((item) =>DirectoryOS.fromJson(item))
          .toList();


  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = StorageHelper.encode(value);
    prefs.setString(key, encoded);
  }

  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString(key) == null  ){
      return null;
    }
    List<DirectoryOS> decode = StorageHelper.decode(prefs.getString(key));
    return decode;
  }
}