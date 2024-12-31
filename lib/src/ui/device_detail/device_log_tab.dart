import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Diese Klasse zeigt die Logdaten der App an.
class DeviceLogTab extends StatelessWidget {
  const DeviceLogTab({super.key});

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

  @override
  Widget build(BuildContext context) => Consumer<BleLogger>(
        builder: (context, logger, _) => Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                thickness: 8,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: scrollController,
                  padding:
                      EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 1),
                  itemBuilder: (context, index) => Text(
                    widget.messages[index],
                    softWrap: false,
                  ),
                  itemCount: widget.messages.length,
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      logger.clearLogs();
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.clear),
                ),
              ],
            )
          ],
        ),
      );
}
