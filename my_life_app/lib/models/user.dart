// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';

class UserApp {
  static String? name;
  static int? id;
  static String numberPhone = '';
  static List<XFile?>? imageList;
  UserApp();

  static void setphone(String phone) {
    numberPhone = phone;
  }

  static String getName() => name!;
  static int getId() => id!;
  static String getPhone() => numberPhone;
  static List<XFile?> getImageList() => imageList!;
}
