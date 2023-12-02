import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/medicine.dart';

class MedicationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMedication(Medicine medicine) async {
    // Assuming you want to generate a new ID if none is provided:
    DocumentReference documentReferencer = 
        medicine.id.isNotEmpty 
            ? firestore.collection('medications').doc(medicine.id)
            : firestore.collection('medications').doc(); // Firestore generates the ID automatically

    await documentReferencer.set(medicine.toJson()).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }
}