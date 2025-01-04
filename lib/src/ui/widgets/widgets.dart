import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:inowa/src/ui/settings/internal/color_theme.dart';

class BluetoothIcon extends StatelessWidget {
  const BluetoothIcon({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 32,
        height: 32,
        child: Align(alignment: Alignment.center, child: Icon(Icons.bluetooth)),
      );
}

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
}

class VSpace extends StatelessWidget {
  const VSpace({super.key, this.flex = 1});

  final double flex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10 * flex,
        ),
      ],
    );
  }
}

class HSpace extends StatelessWidget {
  const HSpace({super.key, this.flex = 1});

  final double flex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 10 * flex,
        ),
      ],
    );
  }
}

// Verschiedene Widget Properties, zur Vereinheitlichung hier abgelegt.
InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  // isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
  border: outlineInputBorder(),
);

InputDecoration inputDecoration({String? hintText, Widget? suffixIcon}) {
  return InputDecoration(
    constraints: BoxConstraints.tight(const Size.fromHeight(50)),
    hintText: hintText,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: _borderRadius,
    ),
    errorStyle: TextStyle(
      fontSize: 14.0, // Smaller text for error message
      height: 0.8, // Adjust height for compactness
    ),
  );
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: _borderRadius,
  );
}

String? integerOutOfRangeValidator(
    {required BuildContext context,
    required String value,
    int? minValue,
    int? maxValue}) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.required;
  }
  var intValue = int.parse(value);
  if (minValue != null && maxValue != null) {
    if (intValue < minValue || intValue > maxValue) {
      return '${AppLocalizations.of(context)!.err_value_out_of_range}($minValue - $maxValue)';
    }
  } else if (minValue != null && maxValue == null) {
    if (intValue < minValue) {
      return '${AppLocalizations.of(context)!.err_value_out_of_range}($minValue - n)';
    }
  } else if (maxValue != null && minValue == null) {
    if (intValue > maxValue) {
      return '${AppLocalizations.of(context)!.err_value_out_of_range}(n - $maxValue)';
    }
  } else {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.required;
    }
  }
  return null;
}

String? textOutOfLengthValidator(
    {required BuildContext context,
    required String value,
    int? minLength,
    int? maxLength}) {
  var length = value.length;
  if (minLength != null && maxLength != null) {
    if (length < minLength || length > maxLength) {
      return '${AppLocalizations.of(context)!.err_value_out_of_range}($minLength - $maxLength)';
    }
  } else if (minLength != null && maxLength == null) {
    if (length < minLength) {
      return '${AppLocalizations.of(context)!.err_value_out_of_range}($minLength - n)';
    }
  } else if (maxLength != null && minLength == null) {
    if (length > maxLength) {
      return '${AppLocalizations.of(context)!.err_value_out_of_range}(n - $maxLength)';
    }
  } else {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.required;
    }
  }

  return null;
}

BorderRadius get _borderRadius => BorderRadius.circular(8);

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

/// Dieses Widget erzeugt ein "Fehler" Banner.
class ErrorBanner extends StatefulWidget {
  const ErrorBanner(
      {super.key, required this.errorMessage, required this.onClearError});

  final String errorMessage;
  final VoidCallback onClearError;

  @override
  State<ErrorBanner> createState() => _ErrorBannerState();
}

class _ErrorBannerState extends State<ErrorBanner> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible(),
      child: Column(
        children: [
          MaterialBanner(
            backgroundColor: ColorTheme.errorContainer(context),
            content: SelectableText(
              widget.errorMessage,
              style: TextStyle(color: ColorTheme.error(context)),
            ),
            actions: [
              TextButton(
                onPressed: widget.onClearError,
                child: Text(
                  AppLocalizations.of(context)!.dismiss,
                  style: TextStyle(color: ColorTheme.error(context)),
                ),
              ),
            ],
            contentTextStyle:
                TextStyle(color: ColorTheme.errorContainer(context)),
            padding: const EdgeInsets.all(10),
          ),
          const VSpace(),
        ],
      ),
    );
  }

  bool isVisible() => widget.errorMessage.isNotEmpty;
}

/// Klasse zur Anzeige einer "SnackBar" am unteren Bildschirmrand.
/// Die SnackBar verschwindet nach einiger Zeit automatisch.
class ScaffoldSnackbar {
  // ignore: public_member_api_docs
  ScaffoldSnackbar(this._context);

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  final BuildContext _context;

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

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
