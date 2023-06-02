import 'package:flutter/material.dart';
import 'package:my_life_web/models/colors.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).canvasColor,
        boxShadow: const [BoxShadow()],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.1,
            height: size.height * 0.15,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Image.asset(
              'assets/images/avatar.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Người gửi: Nguyễn Thành Tiến',
                style: TextStyle(color: WebColor.white),
              ),
              Text(
                'Vị trí: 29, Đường 904, Phường Hiệp Phú, Quận 9, TP. Hồ Chí Minh',
                style: TextStyle(color: WebColor.white),
              ),
              Text(
                'Nội dung: hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
                style: TextStyle(color: WebColor.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
