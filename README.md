# iNoWa Spielwiese

Projekt zum Erlernen von Flutter auf Basis des Beispielprojekts der [flutter_reactive_ble](https://github.com/PhilipsHue/flutter_reactive_ble) Bibliothek.

## Anpassungen

Zum Zeitpunkt Übertragung des Projekts nach GitHub waren bereits folgende Änderungen getan.

### Fehlerkorrekturen

- `LateInitializationError` nach der Auswahl eines Gerätes und Rückkehr zur Geräteliste ohne das Gerät verbunden zu haben.
- Characteristics Kacheln ließen sich nicht aufklappen.
- `LateInitializationError` nach dem Öffnen des **Select an operation** Dialogs.

### Änderungen

- Filtern gefundener Geräte nach einem generischen Gerätenamen, zum Beispiel: **iNoWa\***
- Automatischer Start des Scanvorgangs beim Öffnen der App.
- Automatisches Verbinden mit dem **iNoWa** Peripheral Gerät, insofern es gefunden worden ist.
- Senden von Text (Boulder Zügen) anstelle von Integer Werten an das Peripheral.

### Bluetooth LE

Bluetooth LE wird mit Hilfe der [flutter_reactive_ble](https://pub.dev/packages/flutter_reactive_ble) Bibliothek eingebunden.

Einbinden der Bibliothek:

```bash
dart pub global activate melos
melos bootstrap
flutter pub add flutter_reactive_ble
```
<details>
<summary>Bluetooth Berechtigungen für Android</summary>

Die Berechtigungen werden in der Datei `[project_home]\android\app\src\main\AndroidManifest.xml` abgelegt:

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

```xml
    <uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" android:maxSdkVersion="30" />

    <application>
    ...
    </application>
</manifest>
```

</details>

<details>
<summary>Bluetooth Berechtigungen für iOS</summary>

Die Berechtigungen werden in der Datei `[project_home]\android\app\src\main\AndroidManifest.xml` abgelegt:

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <!-- iOS13 and higher -->
        <key>NSBluetoothAlwaysUsageDescription</key>
        <string>This app needs access to Bluetooth to function properly.</string>
        <!-- iOS12 and lower -->
        <key>NSBluetoothPeripheralUsageDescription</key>
        <string>This app needs access to Bluetooth to function properly.</string>
        ```
    </dict>
</plist>
```

</details>
<p>

## Bibliotheken

- [Flutter Bluetooth Library](https://pub.dev/packages/flutter_reactive_ble)

## Internationalisierung

Siehe hierzu: [Internationalizing Flutter apps](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)

Der Befehl `flutter gen-l10n` nach jeder Änderung einer Sprachkonstanten ausgeführt werden:

- app_en.arb (Default Sprache)
- app_de.arb

## Erstellen einer .apk Datei

Bauen der `.aab` Datei im Zielordner `[project_home]\build\app\outputs\bundle\release\`:

```bash
flutter build appbundle
```

Bauen der `.apk` Datei im Zielordner `[project_home]\build\app\outputs\flutter-apk\`:

```bash
flutter build apk --split-per-abi
```

Zielordner: `[project_home]\build\app\outputs\flutter-apk\`

## Dokumentation

- [The right way to create a Flutter project](https://themobilecoder.com/the-right-way-to-create-a-flutter-project/)
- [Working with locales](https://stackoverflow.com/questions/50923906/how-to-get-timezone-language-and-county-id-in-flutter-by-the-location-of-device)
- [Flutter Templates](https://www.fluttertemplates.dev/widgets/must_haves/)
