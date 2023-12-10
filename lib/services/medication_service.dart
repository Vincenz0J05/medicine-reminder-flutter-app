import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/medicine.dart';

// A service class for handling medication data operations with Firestore.
class MedicationService {
  // Reference to the 'medicine' collection in Firestore.
  final CollectionReference medicineCollection =
      FirebaseFirestore.instance.collection('medicine');

  // Fetches medicines from Firestore based on the day of the week.
  Stream<QuerySnapshot> fetchMedicine(DateTime date) {
    // Formats the date to get the full name of the day of the week.
    String dayOfWeek = DateFormat('EEEE').format(date);

    // Returns a stream of snapshots containing medicines for the given day.
    return medicineCollection.where('days', arrayContains: dayOfWeek).snapshots();
  }

  // Creates a new medicine document in Firestore and returns its ID.
  Future<String> createMedicine(Medicine medicine) async {
    DocumentReference docRef = await medicineCollection.add(medicine.toJson());
    return docRef.id; // Returns the generated ID of the new document.
  }

  // Updates an existing medicine document in Firestore.
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

  // Deletes a medicine document from Firestore using its ID.
  Future<void> deleteMedicine(String id) async {
    try {
      await medicineCollection.doc(id).delete();
      if (kDebugMode) {
        print('Medicine deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting medicine: $e');
      }
    }
  }
}
