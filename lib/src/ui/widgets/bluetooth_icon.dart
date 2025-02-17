import 'package:flutter/material.dart';

class BluetoothIcon extends StatelessWidget {
  const BluetoothIcon({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 32,
        height: 32,
        child: Align(alignment: Alignment.center, child: Icon(Icons.bluetooth)),
      );
}
