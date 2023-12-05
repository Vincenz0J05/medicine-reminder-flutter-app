import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/medicine.dart';

class MedicationService {
  final CollectionReference medicineCollection =
      FirebaseFirestore.instance.collection('medicine');

  Stream<QuerySnapshot> fetchMedicine() {
    return medicineCollection.snapshots();
  }

  Future<void> createMedicine(Medicine medicine) async {
    try {
      await medicineCollection.add(medicine.toJson());
      if (kDebugMode) {
        print('Medicine added successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding medicine: $e');
      }
    }
  }
}
