import 'package:flutter/material.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/ui/home/dialogs/boulder_add_to_list_dialog.dart';

Widget BoulderPopupMenu(
    {required BuildContext context, required FbBoulder itemItem}) {
  return PopupMenuButton<String>(
    icon: Icon(Icons.menu),
    onSelected: (String value) => showDialog<void>(
      context: context,
      builder: (context) => BoulderAddToListDialog(list: value),
    ),
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'Value1',
        child: Text('Choose value 1'),
      ),
      const PopupMenuItem<String>(
        value: 'Value2',
        child: Text('Choose value 2'),
      ),
      const PopupMenuItem<String>(
        value: 'Value3',
        child: Text('Choose value 3'),
      ),
    ],
  );
}
