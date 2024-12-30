import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/main.dart';
import 'package:inowa/src/constants.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

/// Diese Klasse ist ein Popup Dialog mit Informationen zur App.
class AboutPopup extends StatefulWidget {
  const AboutPopup({
    super.key,
  });

  @override
  State<AboutPopup> createState() => _AboutPopupState();
}

class _AboutPopupState extends State<AboutPopup> {
  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      icon: const Icon(
        Icons.info,
      ),
      applicationIcon: const FlutterLogo(),
      applicationName: packageInfo.appName,
      applicationVersion: packageInfo.version,
      aboutBoxChildren: [
        UrlLink(
          label: AppLocalizations.of(context)!.app_project,
          url: URL_APP_PROJECT,
        ),
        const VSpace(),
        UrlLink(
          label: AppLocalizations.of(context)!.indoor_north_wall,
          url: URL_INOWA_HOMPAGE,
        ),
      ],
      child: Text(AppLocalizations.of(context)!.about_colon +
          ' ' +
          packageInfo.appName),
    );
  }
}
