// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';

class UserApp {
  String name;
  int id;
  int numberPhone;
  List<XFile?> imageList;
  UserApp(
    this.name,
    this.id,
    this.numberPhone,
    this.imageList,
  );

  getName() => name;
  getId() => id;
  getPhone() => numberPhone;
  getImageList() => imageList;
}
