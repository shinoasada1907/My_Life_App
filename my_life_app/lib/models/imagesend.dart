// ignore_for_file: file_names

class ImageSeding {
  final String status;
  final String percent;
  final String mask;

  ImageSeding(
      {required this.status, required this.percent, required this.mask});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'percent': percent,
      'mask': mask,
    };
  }

  factory ImageSeding.fromJson(dynamic json) {
    return ImageSeding(
      status: json['status'].toString(),
      percent: json['phantram'].toString(),
      mask: json['mask'].toString(),
    );
  }
}
