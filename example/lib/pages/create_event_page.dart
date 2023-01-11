import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../extension.dart';
import '../widgets/add_event_widget.dart';

class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
        title: Text(
          "Create New Event",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: AddEventWidget(
          onEventAdd: context.pop,
        ),
      ),
    );
  }
}

class CreateEventDialog extends StatelessWidget {
  const CreateEventDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create new event",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 3,
            ),
            child: Column(
              children: [
                Divider(),
                SizedBox(
                  height: 20.0,
                ),
                AddEventWidget(
                  onEventAdd: context.pop,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
