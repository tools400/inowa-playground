import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/settings/ui_settings.dart';
import 'package:inowa/src/ui/about/about_popup.dart';
import 'package:inowa/src/ui/logging/LoggerScreen.dart';
import 'package:inowa/src/ui/profile/profile_screen.dart';
import 'package:inowa/src/ui/settings/settings_screen.dart';
import 'package:inowa/src/utils/utils.dart';

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
                  Utils.openScreen(context, const ProfileScreen());
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.mnu_Settings),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Utils.openScreen(context, const SettingsScreen());
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.mnu_Logging),
                leading: const Icon(Icons.find_in_page),
                onTap: () {
                  Utils.openScreen(context, const LoggerScreen());
                },
              ),
              AboutPopup(),
            ],
          ),
        );
      });
}
