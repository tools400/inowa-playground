import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

/// Dieses Widget erzeugt ein Passwort Eingabefeld.
class PasswordText extends StatefulWidget {
  const PasswordText(
      {super.key, required this.errorText, required this.controller});

  final String? errorText;
  final TextEditingController controller;

  @override
  State<PasswordText> createState() => _PasswordTextState();
}

class _PasswordTextState extends State<PasswordText> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        obscureText: !passwordVisible,
        decoration: inputDecoration(
          hintText: AppLocalizations.of(context)!.password,
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
        validator: (value) =>
            value != null && value.isNotEmpty ? null : widget.errorText,
      );
}
