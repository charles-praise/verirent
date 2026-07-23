import 'package:flutter/material.dart';

/// Shared JSON (de)serialization helpers used across model files.
/// Centralizing these avoids repeating the same null-safe casts in every
/// fromJson/toJson pair.
class JsonHelpers {
  const JsonHelpers._();

  static Color? colorFromJson(dynamic value) =>
      value == null ? null : Color(value as int);

  static int? colorToJson(Color? color) => color?.value;

  static DateTime? dateFromJson(dynamic value) =>
      value == null ? null : DateTime.parse(value as String);

  static String? dateToJson(DateTime? value) => value?.toIso8601String();

  static List<String>? stringListFromJson(dynamic value) =>
      (value as List<dynamic>?)?.map((e) => e as String).toList();

  static Map<String, String>? stringMapFromJson(dynamic value) =>
      (value as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as String));
}
