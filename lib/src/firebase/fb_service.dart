import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/firebase/angle_enum.dart';
import 'package:inowa/src/firebase/grade_enum.dart';

class FirebaseService {
  FirebaseService(this.logger);

  static const collection_boulder = 'boulder';

  BleLogger logger;

  CollectionReference<Map<String, dynamic>> get collectionBoulder =>
      FirebaseFirestore.instance.collection(collection_boulder);

  Stream<QuerySnapshot<Map<String, dynamic>>> get boulderStream =>
      collectionBoulder.snapshots();

  Future<int> numBoulders() async {
    CollectionReference<Map<String, dynamic>> collectionRef = collectionBoulder;
    AggregateQuerySnapshot snapshot = await collectionRef.count().get();
    int count = snapshot.count ?? 0;
    return count;
  }

  Future<void> addBoulder(String name, Angle angle, Grade grade) async {
    try {
      await collectionBoulder.add({
        'id': Uuid().v7(),
        'name': name,
        'angle': angle.id,
        'grade': grade.id,
        'created': FieldValue.serverTimestamp(), // Zeitstempel hinzufügen
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
      logger.debug('Daten erfolgreich hinzugefügt!');
    } catch (e) {
      logger.error('Fehler beim Hinzufügen der Daten: $e');
    }
  }
}
