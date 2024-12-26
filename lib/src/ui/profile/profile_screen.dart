import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/settings/locale_model.dart';
import 'package:provider/provider.dart';

/// Diese Klasse pflegt die Einstellungen der App.
/// Basiert auf: [Simple Settings Page](https://www.fluttertemplates.dev/widgets/must_haves/settings_page#settings_page_2).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer<BleLogger>(builder: (_, bleLogger, __) => _Profile());
}

class _Profile extends StatefulWidget {
  _Profile();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  @override
  Widget build(BuildContext context) =>
      Consumer2<UIModel, BleLogger>(builder: (_, uiModel, bleLogger, __) {
        return Theme(
          data: uiModel.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Settings"),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: ListView(
                  children: const [
                    _SingleSection(
                      children: [
                        _CustomListTile(
                            title: "Sign out", icon: Icons.exit_to_app_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
