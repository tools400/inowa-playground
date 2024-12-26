import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/settings/ui_model.dart';
import 'package:inowa/src/ui/about/about_popup.dart';
import 'package:inowa/src/ui/profile/profile_screen.dart';
import 'package:inowa/src/ui/settings/settings_screen.dart';
import 'package:provider/provider.dart';

/// Diese Klasse ist der Home-Screen der App.
/// Folgende Interaktionen sind möglich:
/// * Starten Scanvorgang
/// * Beenden Scanvorgang
/// * Ein-/ausschalten des erweiterten Loggings
/// * Auswahl eines Geräts aus der Liste gefundener Geräte
class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({
    super.key,
  });

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(BuildContext context) =>
      Consumer<UIModel>(builder: (_, uiModel, __) {
        return Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text(
                  "Thomas Raddatz",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "thomas.raddatz@tools400.de",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: FlutterLogo(),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.mnu_Home),
                leading: const Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.mnu_Profile),
                leading: const Icon(Icons.person),
                onTap: () {
                  openScreen(context, const ProfileScreen());
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.mnu_Settings),
                leading: const Icon(Icons.settings),
                onTap: () {
                  openScreen(context, const SettingsScreen());
                },
              ),
              AboutPopup(),
            ],
          ),
        );
      });

  /// Open the selected screen.
  void openScreen(BuildContext context, Widget screen) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }
}
