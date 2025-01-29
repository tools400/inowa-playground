import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:inowa/src/ui/widgets/cancel_button.dart';
import 'package:inowa/src/ui/widgets/ok_button.dart';

import '/src/ui/widgets/widgets.dart';

/// Diese Klasse ist ein Popup Dialog mit Informationen zur App.
class AskForPermissionsPopup extends StatefulWidget {
  const AskForPermissionsPopup({
    super.key,
    required List<Permission> permissions,
  }) : _permissions = permissions;

  final List<Permission> _permissions;

  static final int buttonCanceled = 1;
  static final int buttonConfirmed = 2;

  @override
  State<AskForPermissionsPopup> createState() => _AskForPermissionsPopupState();
}

class _AskForPermissionsPopupState extends State<AskForPermissionsPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.hdg_missing_permissions),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(AppLocalizations.of(context)!.txt_permission_description),
            VSpace(),
            Row(
              children: [
                Text('• '),
                for (int i = 0; i < widget._permissions.length; i++)
                  Text(widget._permissions[i].toString())
              ],
            ),
            VSpace(),
            Text(AppLocalizations.of(context)!.txt_grant_permissions),
          ],
        ),
      ),
      actions: <Widget>[
        CancelButton(
          onPressed: () {
            Navigator.of(context).pop(AskForPermissionsPopup.buttonCanceled);
          },
        ),
        OKButton(
          onPressed: () {
            Navigator.of(context).pop(AskForPermissionsPopup.buttonConfirmed);
          },
        ),
      ],
    );
  }
}
