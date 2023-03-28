// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

class NotificationModel {
  final String? url;
  final String? location;
  final String? comment;
  final String? status;
  final String? date;

  NotificationModel(
      {this.date, this.url, this.location, this.comment, this.status});
}

List<NotificationModel> notifiList = [
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2022-02-12',
    location: 'Hồ Chí Minh',
    status: 'Đang xử lý',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2022-03-12',
    location: 'Hồ Chí Minh',
    status: 'Đã xử lý',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2022-06-12',
    location: 'Hồ Chí Minh',
    status: 'Đã gửi',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2022-02-20',
    location: 'Hồ Chí Minh',
    status: 'Đang xử lý',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2021-02-12',
    location: 'Hồ Chí Minh',
    status: 'Đang xử lý',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2022-02-12',
    location: 'Hồ Chí Minh',
    status: 'Đã xử lý',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2020-05-12',
    location: 'Hồ Chí Minh',
    status: 'Đã gửi',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2022-02-24',
    location: 'Hồ Chí Minh',
    status: 'Đang xử lý',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
  NotificationModel(
    url: 'assets/images/anh_duong.jpg',
    date: '2022-02-12',
    location: 'Hồ Chí Minh',
    status: 'Đang xử lý',
    comment:
        'Đường hư nhiều quá, đường thì lỏm chỏm búa lua xua hết làm ăn như shit vậy còn không mau đưa người tới xử lý đi chứ đcm ',
  ),
];

// enum status { sended, processing, processed }
