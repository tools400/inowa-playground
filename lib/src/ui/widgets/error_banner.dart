import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

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
