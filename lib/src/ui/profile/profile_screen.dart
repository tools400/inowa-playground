import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Diese Klasse pflegt die Einstellungen der App.
/// Basiert auf: [Simple Settings Page](https://www.fluttertemplates.dev/widgets/must_haves/settings_page#settings_page_2).
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Öffnen Google "Profile" Bildschirm
    return ProfileScreen(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mnu_Profile),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      actions: [
        SignedOutAction((context) {
          Navigator.of(context).pop();
        })
      ],
      children: [
/*
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(2),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('assets/flutterfire_300x.png'),
          ),
        ),
*/
      ],
    );
  }
}
