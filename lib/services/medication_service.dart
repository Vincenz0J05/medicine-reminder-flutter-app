import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/medicine.dart';

class MedicationService {
  final CollectionReference medicineCollection =
      FirebaseFirestore.instance.collection('medicine');

  Stream<QuerySnapshot> fetchMedicine() {
    return medicineCollection.snapshots();
  }

  Future<String> createMedicine(Medicine medicine) async {
    DocumentReference docRef = await medicineCollection.add(medicine.toJson());
    return docRef.id; // Return the generated ID of the new document
  }

  Future<void> updateMedicine(Medicine medicine) async {
    if (medicine.id == null) {
      throw Exception("Medicine ID is null");
    }

    try {
      await medicineCollection.doc(medicine.id).update(medicine.toJson());
      if (kDebugMode) {
        print('Medicine updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating medicine: $e');
      }
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      await medicineCollection.doc(id).delete();
      if (kDebugMode) {
        print('Medicine deleted succesfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting medicine: $e');
      }
    }
  }
}
