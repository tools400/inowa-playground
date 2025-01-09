import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Dieses Widget erzeugt einen Link zum Zurücksetzen
/// des Passworts.
class ResetPasswordLink extends StatelessWidget {
  const ResetPasswordLink({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        child: Text(AppLocalizations.of(context)!.txt_forgot_Password),
      );
}
