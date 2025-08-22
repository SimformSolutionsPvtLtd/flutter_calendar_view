import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

class DeleteEventDialog extends StatefulWidget {
  @override
  _RadioDialogState createState() => _RadioDialogState();
}

class _RadioDialogState extends State<DeleteEventDialog> {
  DeleteEvent _selectedOption = DeleteEvent.current;

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;

    return AlertDialog(
      title: Text(translate.deleteRecurringEvent),
      content: RadioGroup(
        groupValue: _selectedOption,
        onChanged: (deleteType) {
          if (deleteType != null) {
            setState(() => _selectedOption = deleteType);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: Text(translate.thisEvent),
              value: DeleteEvent.current,
            ),
            RadioListTile(
              title: Text(translate.thisAndFollowingEvents),
              value: DeleteEvent.following,
            ),
            RadioListTile(title: Text(translate.allEvents), value: DeleteEvent.all),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(translate.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selectedOption),
          child: Text(translate.done),
        ),
      ],
    );
  }
}
