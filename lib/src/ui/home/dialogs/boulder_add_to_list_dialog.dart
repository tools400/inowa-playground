import 'package:flutter/material.dart';

import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/ui/home/dialogs/boulder_add_to_list_dialog.dart';

class BoulderAddToListDialog extends StatefulWidget {
  const BoulderAddToListDialog({
    required this.list,
  });

  final String list;

  @override
  _BoulderAddToListDialogState createState() => _BoulderAddToListDialogState();
}

class _BoulderAddToListDialogState extends State<BoulderAddToListDialog> {
  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
            padding: appBorder,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.list),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'))
              ],
            )),
      );
}
