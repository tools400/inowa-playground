import 'package:flutter/material.dart';
import 'package:inowa/src/widgets.dart';

/// Diese Klasse ist ein Popup Dialog mit Informationen zur App.
class AboutPopup extends StatelessWidget {
  const AboutPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AboutListTile(
      icon: Icon(
        Icons.info,
      ),
      applicationIcon: FlutterLogo(),
      applicationName: 'iNoWa',
      applicationVersion: '0.0.1',
      applicationLegalese: '(c) 2024, Thomas Raddatz',
      aboutBoxChildren: [
        VSpace(),
        Text('Something about the app..'),
        Text('Second line.'),
      ],
      child: Text('About app'),
    );
  }
}
