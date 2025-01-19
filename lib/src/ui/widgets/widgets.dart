import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

BorderRadius get _borderRadius => BorderRadius.circular(8);

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

const appBorder = EdgeInsets.all(8);

const sectionBorder = EdgeInsets.all(8);

const errorBannerBorder = EdgeInsets.all(8);

InputDecorationTheme get inputDecorationTheme {
  return InputDecorationTheme(
    // isDense: true,
    contentPadding: appBorder,
    constraints: boxContraints,
    border: outlineInputBorder,
  );
}

/// Darstellung von Text und Integer Felder.
InputDecoration inputDecoration({String? hintText, Widget? suffixIcon}) {
  return InputDecoration(
    constraints: boxContraints,
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

const double widgetWidth = 200;

const double widgetHeight = 45;

BoxConstraints get boxContraints {
  return BoxConstraints.tight(const Size.fromHeight(widgetHeight));
}

OutlineInputBorder get outlineInputBorder {
  return OutlineInputBorder(
    borderRadius: _borderRadius,
  );
}

String? validateIntNotNull({
  required BuildContext context,
  required String value,
}) {
  return validateIntRange(context: context, value: value);
}

String? validateIntRange({
  required BuildContext context,
  required String value,
  int? minValue,
  int? maxValue,
}) {
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

String? validateTextNotEmpty({
  required BuildContext context,
  required String value,
}) {
  return validateTextLength(context: context, value: value);
}

String? validateTextLength({
  required BuildContext context,
  required String value,
  int? minLength,
  int? maxLength,
}) {
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
