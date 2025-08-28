import 'dart:typed_data';

import 'package:intl/intl.dart';

class PhotoEntity {
  int id;
  DateTime createdTime;
  Uint8List image;

  PhotoEntity({
    required this.id,
    required this.createdTime,
    required this.image,
  });

  factory PhotoEntity.fromJson(Map<String, dynamic> json) {
    return PhotoEntity(
      id: json['id'],
      createdTime: DateTime.parse(json['createdTime']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdTime': createdTime.toIso8601String(),
      'image': image,
    };
  }

  String get createdTimeString {
    return DateFormat('MM/dd/yyyy HH:mm').format(createdTime);
  }
}