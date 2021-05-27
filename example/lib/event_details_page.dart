import 'package:example/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

import 'extension.dart';

class DetailsPage extends StatelessWidget {
  final CalendarEventData event;

  const DetailsPage({Key? key, required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          event.title,
          style: TextStyle(
            color: AppConstants.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: context.popRoute,
          icon: Icon(
            Icons.arrow_back,
            color: AppConstants.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
              "Date: ${event.date.dateToStringWithFormat(format: "dd/MM/yyyy")}"),
          SizedBox(
            height: 15.0,
          ),
          if (event.startTime != null && event.endTime != null) ...[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From"),
                      Text(
                        event.startTime
                                ?.getTimeInFormat(TimeStampFormat.parse_12) ??
                            "",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To"),
                      Text(
                        event.endTime
                                ?.getTimeInFormat(TimeStampFormat.parse_12) ??
                            "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
          if (event.description != "") ...[
            Divider(),
            Text("Description"),
            SizedBox(
              height: 10.0,
            ),
            Text(event.description),
          ]
        ],
      ),
    );
  }
}
