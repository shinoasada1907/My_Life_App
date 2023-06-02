import 'package:flutter/material.dart';
import 'package:my_life_web/screens/minor/container_widget.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 1,
          height: size.height * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Lọc'))
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.8,
          // margin: const EdgeInsets.only(
          //   bottom: 15,
          //   right: 15,
          //   left: 15,
          // ),
          child: ListView.builder(
            itemCount: 20,
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, index) => const ContainerWidget(),
          ),
        ),
      ],
    );
  }
}
