// ignore_for_file: file_names

import 'package:uuid/uuid.dart';

class ImageSeding {
  final String id;
  final String status;
  final String percent;
  final String mask;

  ImageSeding(
      {required this.id,
      required this.status,
      required this.percent,
      required this.mask});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'percent': percent,
      'mask': mask,
    };
  }

  factory ImageSeding.fromJson(dynamic json) {
    return ImageSeding(
      id: const Uuid().v1(),
      status: json['status'].toString(),
      percent: json['phantram'].toString(),
      mask: json['mask'].toString(),
    );
  }
}
