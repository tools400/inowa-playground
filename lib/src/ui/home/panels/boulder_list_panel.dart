import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/ui/home/dialogs/boulder_add_to_list_dialog.dart';
import 'package:inowa/src/ui/home/display_boulder_screen.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';
import 'package:inowa/src/utils/utils.dart';

import '/src/firebase/fb_service.dart';

/// Diese Klasse zeigt die Logdaten der App an.
class BoulderListPanel extends StatelessWidget {
  const BoulderListPanel({super.key});

  @override
  Widget build(BuildContext context) => Consumer<BleLogger>(
        builder: (context, logger, _) => _BoulderListPanel(
          messages: logger.messages,
        ),
      );
}

class _BoulderListPanel extends StatefulWidget {
  const _BoulderListPanel({
    required this.messages,
  });

  final List<String> messages;

  @override
  State<_BoulderListPanel> createState() => _BoulderListPanelState();
}

class _BoulderListPanelState extends State<_BoulderListPanel> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // TODO: add horizontal scrolling of the log messages, disable 'softWrap'.
  @override
  Widget build(BuildContext context) => Consumer<FirebaseService>(
        builder: (context, firebase, _) => StreamBuilder<QuerySnapshot>(
          stream: firebase.boulderStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!
                        .txt_no_boulders_available),
                    if (!firebase.isLoggedIn) ...[
                      VSpace(),
                      Text('Not logged in!'),
                    ]
                  ],
                ),
              );
            }

            final items = snapshot.data!.docs;

            return boulderList(items, context);
          },
        ),
      );

  Column boulderList(
      List<QueryDocumentSnapshot<Object?>> items, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            thickness: 16,
            thumbVisibility: true,
            interactive: true,
            trackVisibility: false,
            child: ListView.builder(
              controller: scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                FbBoulder boulder = FbBoulder(items[index]);
                return BoulderListTile(context, boulder);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BoulderListTile extends StatelessWidget {
  const BoulderListTile(this._context, this._boulderItem, {super.key});

  final BuildContext _context;
  final FbBoulder _boulderItem;

  @override
  Widget build(BuildContext context) {
    int stars = _boulderItem.stars;
    int maxStars = 5;

    final numStars = <Widget>[];
    for (var i = 0; i < maxStars; i++) {
      numStars.add(i < stars
          ? Icon(Icons.star, color: Colors.yellow)
          : Icon(Icons.star_outline, color: Colors.grey));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: ListTile(
        title: Text(_boulderItem.name),
        onTap: () {
          Utils.openScreen(
              context, DisplayBoulderScreen(boulder: _boulderItem));
        },
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_boulderItem.angleUI}°  / ${_boulderItem.gradeUI}',
              style: TextStyle(fontSize: 12),
            ),
            Row(
              spacing: 0,
              children: numStars,
            )
          ],
        ),
        leading: Icon(Icons.hourglass_bottom),
        trailing: BoulderPopupMenu(context: context, itemItem: _boulderItem),
      ),
    );
  }
}

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
