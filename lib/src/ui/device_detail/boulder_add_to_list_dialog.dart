import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '/src/ble/ble_device_interactor.dart';
import '/src/ui/widgets/widgets.dart';

/// Diese Klasse zeigt einen Dialog für die Interaktion mit einer
/// gegebenen Characteristic.
/// Die möglichen Interaktionen sind:
/// * Read
/// * Write without response
/// * Write with response
/// * Subscribe / notify
class BoulderAddToListDialog extends StatelessWidget {
  const BoulderAddToListDialog({
    required this.list,
    super.key,
  });
  final String list;

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
        builder: (context, interactor, _) =>
            _CharacteristicInteractionDialog(list: list),
      );
}

class _CharacteristicInteractionDialog extends StatefulWidget {
  const _CharacteristicInteractionDialog({
    required this.list,
  });

  final String list;

  @override
  _CharacteristicInteractionDialogState createState() =>
      _CharacteristicInteractionDialogState();
}

class _CharacteristicInteractionDialogState
    extends State<_CharacteristicInteractionDialog> {
  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
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
