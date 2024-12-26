enum UIThemeMode {
  system(label: 'System'),
  dark(label: 'Dark'),
  light(label: 'Light');

  const UIThemeMode({
    required this.label,
  });

  final String label;
}
