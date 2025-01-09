import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

/// Dieses Widget erzeugt ein Email Eingabefeld.
class EmailText extends StatelessWidget {
  const EmailText({super.key, this.email, required this.controller});

  final String? email;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextFormField(
        initialValue: email,
        controller: controller,
        decoration:
            inputDecoration(hintText: AppLocalizations.of(context)!.email),
/*        
        InputDecoration(
          hintText: AppLocalizations.of(context)!.email,
          border: const OutlineInputBorder(),
        ),
*/
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        validator: (value) => value != null && value.isNotEmpty
            ? null
            : AppLocalizations.of(context)!.required,
      );
}
