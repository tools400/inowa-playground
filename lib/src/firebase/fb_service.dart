import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'package:inowa/main.dart';

import '/src/firebase/angle_enum.dart';
import '/src/firebase/grade_enum.dart';

class FirebaseService {
  FirebaseService();

  static const collection_boulder = 'boulder';

  bool get isLoggedIn {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  }

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
        'grade': grade.value,
        'created': FieldValue.serverTimestamp(), // Zeitstempel hinzufügen
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
      bleLogger.debug('Daten erfolgreich hinzugefügt!');
    } catch (e) {
      bleLogger.debug('Fehler beim Hinzufügen der Daten: $e');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> boulderStreamFiltered(
          FilterOptions filterOptions) =>
      collectionBoulder
          .where("grade", isGreaterThanOrEqualTo: filterOptions.fromGrade.value)
          .where("grade", isLessThanOrEqualTo: filterOptions.toGrade.value)
          .snapshots();
}

class FilterOptions {
  FilterOptions();

  Grade _fromGrade = Grade.min;
  Grade _toGrade = Grade.max;

  Grade get fromGrade => _fromGrade;
  set fromGrade(Grade grade) {
    _fromGrade = grade;
  }

  Grade get toGrade => _toGrade;
  set toGrade(Grade grade) {
    _toGrade = grade;
  }
}
