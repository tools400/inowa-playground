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
