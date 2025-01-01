import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '/src/ble/ble_logger.dart';
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
                    OutlinedButton(
                      onPressed: () {
                        // openScreen(context, AddBoulderScreen());
                      },
                      child: Text('Add'),
                    ),
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
            thickness: 8,
            thumbVisibility: true,
            child: ListView.builder(
              controller: scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final name = item['name'];
                final angle = item['angle'];
                final grade = item['grade'];

                return ListTile(
                  title: Text(name),
                  subtitle: Text('$angle / $grade'),
                );
              },
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            //openScreen(context, AddBoulderScreen());
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
