import 'package:my_life_app/models/imagesend.dart';
import 'package:my_life_app/models/location.dart';

class Reflect {
  final String userId;
  final String userName;
  final String numberPhone;
  final String date;
  final String status;
  final String description;
  final String imageReflect;
  final ImageSending imageSending;
  final LocationAddress location;

  Reflect({
    required this.userId,
    required this.userName,
    required this.numberPhone,
    required this.date,
    required this.status,
    required this.description,
    required this.imageReflect,
    required this.imageSending,
    required this.location,
  });
}

class ReviewImage {
  final String userId;
  final String userName;
  final String comment;

  ReviewImage({
    required this.userId,
    required this.userName,
    required this.comment,
  });
}

enum StatusReflect {
  completed,
  processing,
  success,
}
