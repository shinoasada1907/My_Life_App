// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationWidget extends StatelessWidget {
  NotificationWidget({
    required this.index,
    super.key,
    required this.url,
    required this.date,
    required this.location,
    this.comment,
    required this.status,
  });
  int index;
  final String url;
  final String date;
  final String location;
  final String? comment;
  final String status;

  bool checknull(String? comment) {
    if (comment != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: Colors.black45,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Image(
                  image: AssetImage(
                    url,
                  ),
                  width: 130,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Color.fromARGB(218, 7, 201, 245),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(DateTime.parse(date)),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 221, 24, 10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.green,
                      ),
                      Text(status),
                    ],
                  ),
                ],
              ),
            ],
          ),
          checknull(comment)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: Text(
                    comment!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
