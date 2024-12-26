import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/constants.dart';
import 'package:inowa/src/widgets.dart';

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
      child: Text(
          AppLocalizations.of(context)!.about_colon + ' ' + APPLICATION_TITLE),
      icon: const Icon(
        Icons.info,
      ),
      applicationIcon: const FlutterLogo(),
      applicationName: 'packageInfo.appName',
      applicationVersion: APPLICATION_VERSION,
      aboutBoxChildren: [
        UrlLink(
          label: AppLocalizations.of(context)!.app_project,
          url: URL_APP_PROJECT,
        ),
        VSpace(),
        UrlLink(
          label: AppLocalizations.of(context)!.indoor_north_wall,
          url: URL_INOWA_HOMPAGE,
        ),
      ],
    );
  }
}
