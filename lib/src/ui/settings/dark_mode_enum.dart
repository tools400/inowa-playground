enum DarkMode {
  system(label: 'System'),
  dark(label: 'Dark'),
  light(label: 'Light');

  const DarkMode({
    required this.label,
  });

  final String label;
}
