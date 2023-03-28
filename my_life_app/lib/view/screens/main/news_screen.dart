import 'package:flutter/material.dart';
import 'package:my_life_app/models/news.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/minor/read_news_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('News'),
          actions: [
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/avatar.jpg'))),
            )
          ],
          backgroundColor: AppStyle.mainColor,
        ),
        body: ListView.builder(
          itemCount: newslist.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadNewsScreen(
                        index: index,
                      ),
                    ));
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      newslist[index].url!,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        newslist[index].title!,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      newslist[index].description!,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
