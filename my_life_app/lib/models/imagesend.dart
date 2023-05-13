// ignore_for_file: file_names

import 'package:uuid/uuid.dart';

class ImageSending {
  final String id;
  final String status;
  final String percent;
  final String mask;

  ImageSending(
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

  factory ImageSending.fromJson(dynamic json) {
    return ImageSending(
      id: const Uuid().v1(),
      status: json['status'].toString(),
      percent: json['phantram'].toString(),
      mask: json['mask'].toString(),
    );
  }
}
