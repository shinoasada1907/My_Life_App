import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';

import '../minor/near_location.dart';
import '../minor/news_screen.dart';

class UserScreen extends StatefulWidget {
  final String documentId;
  const UserScreen({required this.documentId, super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppStyle.mainColor,
          toolbarHeight: size.height * 0.01,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Tin tức',
                icon: Icon(
                  Icons.newspaper,
                ),
              ),
              Tab(
                text: 'Gần đây',
                icon: Icon(
                  Icons.location_on,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const NewsScreen(),
            NearLocationUser(documentId: widget.documentId),
          ],
        ),
      ),
    );
  }
}
