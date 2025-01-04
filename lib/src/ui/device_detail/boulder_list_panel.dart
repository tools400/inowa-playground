import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/ui/device_detail/boulder_add_to_list_dialog.dart';
import 'package:inowa/src/ui/home/display_boulder_screen.dart';
import 'package:inowa/src/utils/utils.dart';

import '/src/firebase/fb_service.dart';

/// Diese Klasse zeigt die Logdaten der App an.
class BoulderListPanel extends StatelessWidget {
  const BoulderListPanel({super.key});

  @override
  Widget build(BuildContext context) => Consumer<BleLogger>(
        builder: (context, logger, _) => _DeviceLogTab(
          messages: logger.messages,
        ),
      );
}

class _DeviceLogTab extends StatefulWidget {
  const _DeviceLogTab({
    required this.messages,
  });

  final List<String> messages;

  @override
  State<_DeviceLogTab> createState() => _DeviceLogTabState();
}

class _DeviceLogTabState extends State<_DeviceLogTab> {
  final ScrollController scrollController = ScrollController();

  // TODO: add horizontal scrolling of the log messages, disable 'softWrap'.
  @override
  Widget build(BuildContext context) => Consumer2<BleLogger, FirebaseService>(
        builder: (context, logger, firebase, _) => StreamBuilder<QuerySnapshot>(
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
                final item = items[index];
                final name = item['name'];
                final angle = item['angle'];
                final grade = item['grade'];

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: ListTile(
                    title: Text(name),
                    onTap: () {
                      displayAndLoadBoulder();
                    },
                    subtitle: Text('$angle / $grade'),
                    leading: Icon(Icons.hourglass_bottom),
                    trailing: boulderPopupMenu(item),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  displayAndLoadBoulder() {
    Utils.openScreen(context, DisplayBoulderScreen());
  }

  Widget boulderPopupMenu(QueryDocumentSnapshot<Object?> item) {
    // return Icon(Icons.menu);

    String? _selection;
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
}
