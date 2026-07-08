import 'package:flutter/material.dart';
import 'package:verirent/core/theme/agents_theme.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String time;
  final String type;
  final bool read;
  final String sender;
  final String avatar;
  final Color color;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.read,
    required this.sender,
    required this.avatar,
    required this.color,
    required this.createdAt,
  });

  factory NotificationModel.fromJson({required Map<String, dynamic> json}) {
    final rawColor = json["color"];
    DateTime parsedDate;
    final rawDate = json["createdAt"];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return NotificationModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      time: json["time"] ?? "",
      sender: json["sender"] ?? "not available",
      avatar: json["avatar"] ?? "",
      color: rawColor is int ? Color(rawColor) : VeriRentColors.tierBasic,
      type: json["type"] ?? "",
      read: json["read"] ?? false,
      createdAt: parsedDate,
    );
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? time,
    String? type,
    bool? read,
    String? sender,
    String? avatar,
    Color? color,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      read: read ?? this.read,
      sender: sender ?? this.sender,
      avatar: avatar ?? this.avatar,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
