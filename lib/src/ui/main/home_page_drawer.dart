import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              // appState.onItemTapped(PageIndex.HomePage);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              // appState.onItemTapped(PageIndex.Profile);
              // Navigator.pop(context);
            },
          ),
          const AboutListTile(
            icon: Icon(
              Icons.info,
            ),
            applicationIcon: FlutterLogo(),
            applicationName: 'iNoWa',
            applicationVersion: '0.0.1',
            applicationLegalese: '(c) 2024, Thomas Raddatz',
            aboutBoxChildren: [
              SizedBox(height: 10),
              Text('Something about the app..'),
              Text('Second line.'),
            ],
            child: Text('About app'),
          ),
        ],
      ),
    );
  }
}
