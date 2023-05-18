// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidget({
    super.key,
    required this.notification,
  });
  dynamic notification;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
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
                  image: NetworkImage(
                    widget.notification['imagereflect'],
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
                        widget.notification['date'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 221, 24, 10),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.notification['address'],
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color:
                            (widget.notification['statusreflect'] == 'Đã gửi')
                                ? Colors.green
                                : (widget.notification['statusreflect'] ==
                                        'Đã tiếp nhận')
                                    ? Colors.red
                                    : Colors.blue,
                      ),
                      Text(widget.notification['statusreflect']),
                    ],
                  ),
                ],
              ),
            ],
          ),
          checknull(widget.notification['description'])
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: Text(
                    widget.notification['description'],
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
