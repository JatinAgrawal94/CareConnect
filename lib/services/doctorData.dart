import 'package:careconnect/screens/medicaldata/doctor_appointment.dart';
import 'package:careconnect/screens/userdataforms/doctor_profile.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/cupertino.dart';

class DoctorData {
  static String doctorId;
  AuthService auth = AuthService();
  String host = "https://careconnect-api.herokuapp.com";
  GeneralFunctions general = GeneralFunctions();
  final doctorInfoKeys = {
    0: 'name',
    1: 'userid',
    2: 'email',
    3: 'dateofbirth',
    4: 'gender',
    5: 'bloodgroup',
    6: 'designation',
    7: 'doctype',
    8: "timing",
    9: 'contact',
    10: 'address'
  };

  String convertDate(String date) {
    var g = date.split('/').reversed.toList();
    if (int.parse(g[1]) / 10 < 1) {
      g[1] = "0" + g[1];
    }

    if (int.parse(g[2]) / 10 < 1) {
      g[2] = "0" + g[2];
    }
    return g.join('-').toString();
  }

  Widget getScreen(int index, String doctorId, String email) {
    if (index == 0) {
      return DoctorProfile(doctorId: doctorId);
    } else {
      return DoctorAppointment(
        doctorId: doctorId,
        email: email,
      );
    }
  }

  // Future createDoctorAppointment(String doctorId, data) async {
  //   CollectionReference appointment =
  //       FirebaseFirestore.instance.collection('Appointment');
  //   await appointment.add({
  //     "date": data["date"],
  //   });
  // }

  Future getAppointmentDates(String email) async {
    var url = Uri.parse('$host/appointment/appointmentdates?email=$email');
    var data = await auth.makeHttpRequest(url, 'get');
    if (data[0].length == 0) {
      return null;
    } else {
      return [data[0], data[1], data[2][0]['timing'], email];
    }
  }

  Future getPatientsBasedOnDateAndDoctor(
      String doctoremail, String date) async {
    var url = '$host/appointment/specific?email=$doctoremail&date=$date';
    var data = await auth.makeHttpRequest(url, 'get');
    return data;
  }

  Future updatePaymentAmount(String doctorEmail, String patientEmail,
      String date, String paymentStatus, String paymentamount) async {
    var body = {
      'doctoremail': doctorEmail,
      'patientemail': patientEmail,
      'date': date,
      'paymentstatus': paymentStatus,
      'paymentamount': paymentamount
    };
    var url = Uri.parse('$host/appointment/updatepaymentamount');
    var data = auth.makeHttpRequest(url, 'post', body: body);
    return data;
  }
}
