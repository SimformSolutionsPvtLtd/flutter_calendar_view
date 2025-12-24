import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class DeleteEventDialog extends StatefulWidget {
  @override
  _RadioDialogState createState() => _RadioDialogState();
}

class _RadioDialogState extends State<DeleteEventDialog> {
  DeleteEvent _selectedOption = DeleteEvent.current;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete recurring event '),
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
              title: Text('This event'),
              value: DeleteEvent.current,
            ),
            RadioListTile(
              title: Text('This and following events'),
              value: DeleteEvent.following,
            ),
            RadioListTile(title: Text('All events'), value: DeleteEvent.all),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selectedOption),
          child: Text('Done'),
        ),
      ],
    );
  }
}
