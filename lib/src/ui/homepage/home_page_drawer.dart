import 'package:flutter/material.dart';
import 'package:inowa/src/ui/about/about_popup.dart';
import 'package:inowa/src/widgets.dart';

/// Diese Klasse ist der Home-Screen der App.
/// Folgende Interaktionen sind möglich:
/// * Starten Scanvorgang
/// * Beenden Scanvorgang
/// * Ein-/ausschalten des erweiterten Loggings
/// * Auswahl eines Geräts aus der Liste gefundener Geräte
class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //Text labelHome = Text(AppLocalizations.of(context)!.homepage);
    //Text labelProfile = Text(AppLocalizations.of(context)!.profile);
    //Text labelFilterBoulders =
    //    Text(AppLocalizations.of(context)!.filterBoulders);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
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
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              // appState.onItemTapped(PageIndex.HomePage);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              // appState.onItemTapped(PageIndex.Profile);
              // Navigator.pop(context);
            },
          ),
          AboutPopup(),
        ],
      ),
    );
  }
}
