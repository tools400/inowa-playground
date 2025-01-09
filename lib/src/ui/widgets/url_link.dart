import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Dieses Widget erzeugt ein Label mit einem Link.
class UrlLink extends StatelessWidget {
  const UrlLink({
    super.key,
    this.label,
    this.url,
  });

  final String? label;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(url!);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: url,
            style: const TextStyle(
              color: ColorTheme.linkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri(
                  scheme: uri.scheme,
                  host: uri.host,
                ));
              },
          ),
        ],
      ),
    );
  }
}
