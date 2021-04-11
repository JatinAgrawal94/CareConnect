import 'package:careconnect/screens/medicaldata/Appointment.dart';
import 'package:careconnect/screens/medicaldata/about_screen.dart';
import 'package:careconnect/screens/medicaldata/allergy_screen.dart';
import 'package:careconnect/screens/medicaldata/blood_glucose.dart';
import 'package:careconnect/screens/medicaldata/blood_pressure.dart';
import 'package:careconnect/screens/medicaldata/examination.dart';
import 'package:careconnect/screens/medicaldata/family_history.dart';
import 'package:careconnect/screens/medicaldata/labtest.dart';
import 'package:careconnect/screens/medicaldata/medical_visit.dart';
import 'package:careconnect/screens/medicaldata/notes.dart';
import 'package:careconnect/screens/medicaldata/pathology.dart';
import 'package:careconnect/screens/medicaldata/radiology.dart';
import 'package:careconnect/screens/medicaldata/surgery.dart';
import 'package:careconnect/screens/medicaldata/vaccine.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careconnect/screens/medicaldata/prescription.dart';

class PatientData {
  final patientInfoKeys = {
    0: 'name',
    1: 'email',
    2: 'dateofbirth',
    3: 'gender',
    4: 'bloodgroup',
    5: 'phoneno',
    6: 'insuranceno',
    7: 'address'
  };

  Widget getDataScreen(int index, String patientId) {
    if (index == 0) {
      return AboutScreen(
        patientId: patientId,
      );
    } else if (index == 1) {
      return AllergyScreen(
        patientId: patientId,
      );
    } else if (index == 2) {
      return BloodGlucoseScreen(patientId: patientId);
    } else if (index == 3) {
      return BloodPressureScreen(patientId: patientId);
    } else if (index == 4) {
      return ExaminationScreen(patientId: patientId);
    } else if (index == 5) {
      return FamilyHistoryScreen(patientId: patientId);
    } else if (index == 6) {
      return LabTestScreen(patientId: patientId);
    } else if (index == 7) {
      return MedicalVisitScreen(patientId: patientId);
    } else if (index == 8) {
      return NotesScreen(patientId: patientId);
    } else if (index == 9) {
      return PathologyScreen(patientId: patientId);
    } else if (index == 10) {
      return PrescriptionScreen(patientId: patientId);
    } else if (index == 11) {
      return RadiologyScreen(patientId: patientId);
    } else if (index == 12) {
      return SurgeryScreen(patientId: patientId);
    } else if (index == 13) {
      return VaccineScreen(patientId: patientId);
    } else {
      return Appointment();
    }
  }

// Reading Data for About Page,medicaldata/about_screen.dart
  Future getPatientInfo(dynamic patientid) async {
    var data = Map<String, dynamic>();
    await FirebaseFirestore.instance
        .collection('Patient')
        .doc(patientid)
        .get()
        .then((DocumentSnapshot snapshot) {
      data = snapshot.data();
    });
    return data;
  }

  Future getAllergyData(dynamic patientid) async {
    var data = Map<String, String>();
    await FirebaseFirestore.instance
        .collection('Patient/$patientid/allergy')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        data['allergyname'] = element['allergyname'];
      });
    });
  }
}
