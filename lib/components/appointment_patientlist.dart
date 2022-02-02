import 'package:careconnect/components/loading.dart';
import 'package:careconnect/screens/medicaldata/about_screen.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/doctorData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

class AppointmentPatientList extends StatefulWidget {
  final String doctoremail;
  final String date;
  AppointmentPatientList({Key key, this.date, this.doctoremail})
      : super(key: key);

  @override
  State<AppointmentPatientList> createState() =>
      _AppointmentPatientListState(this.date, this.doctoremail);
}

class _AppointmentPatientListState extends State<AppointmentPatientList> {
  String date;
  String doctoremail;
  String patientId;
  String paymentAmount;
  DoctorData _doctorData = DoctorData();
  PatientData _patientData = PatientData();
  _AppointmentPatientListState(this.date, this.doctoremail);
  List data = [];
  @override
  void initState() {
    super.initState();
    _doctorData
        .getPatientsBasedOnDateAndDoctor(doctoremail, date)
        .then((value) {
      value.forEach((item) {
        setState(() {
          data.add({
            'patientname': item['patientname'],
            'patientemail': item['patientemail'],
            'reason': item['reason'],
            'visittype': item['visittype'],
            'paymentstatus': item['paymentstatus'],
            'paymentamount': item['paymentamount']
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepPurple,
          title: Text(date),
        ),
        body: data.length == 0
            ? LoadingHeart()
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: List.generate(data.length, (index) {
                      return Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Column(children: <Widget>[
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                    // width: MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          data[index]['patientname'],
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          data[index]['patientemail'],
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Text(
                                          "PatientType: " +
                                              data[index]['visittype'],
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Text(
                                          "Paymentstatus: " +
                                              data[index]['paymentstatus'],
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Text(
                                              "Reason: " +
                                                  data[index]['reason'],
                                              style: TextStyle(fontSize: 17),
                                              maxLines: 20,
                                            )),
                                        // Payment Amount Code
                                        Container(
                                            child: Row(
                                          children: <Widget>[
                                            Text(
                                              "PaymentAmount: ",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            data[index]['paymentamount']
                                                            .trim() ==
                                                        "" ||
                                                    data[index]['paymentamount']
                                                            .trim() ==
                                                        null
                                                ? Row(
                                                    children: <Widget>[
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  15, 0, 15, 0),
                                                          child: Form(
                                                            child:
                                                                TextFormField(
                                                                    cursorColor:
                                                                        Colors
                                                                            .deepPurple,
                                                                    validator:
                                                                        (value) {
                                                                      if (value
                                                                          .isEmpty) {
                                                                        return "Field can't be empty";
                                                                      }
                                                                      return null;
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.deepPurple))),
                                                                    onChanged: (value) {
                                                                      setState(
                                                                          () {
                                                                        paymentAmount =
                                                                            value;
                                                                      });
                                                                    }),
                                                          )),
                                                      Container(
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                if (paymentAmount
                                                                        .trim() !=
                                                                    null) {
                                                                  print(date);
                                                                  _doctorData.updatePaymentAmount(
                                                                      doctoremail,
                                                                      data[index]
                                                                          [
                                                                          'patientemail'],
                                                                      date,
                                                                      data[index]
                                                                          [
                                                                          'paymentstatus'],
                                                                      paymentAmount);
                                                                  return Fluttertoast.showToast(
                                                                      msg:
                                                                          "PaymentAmount Updated !",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .SNACKBAR,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          15,
                                                                      timeInSecForIosWeb:
                                                                          1);
                                                                } else {
                                                                  return Fluttertoast.showToast(
                                                                      msg:
                                                                          "Field can't be empty ! ",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .SNACKBAR,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          15,
                                                                      timeInSecForIosWeb:
                                                                          1);
                                                                }
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .deepPurple),
                                                              child:
                                                                  Text("Save")))
                                                    ],
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: Text(
                                                        "Rs " +
                                                            data[index][
                                                                'paymentamount'],
                                                        style: TextStyle(
                                                            fontSize: 17))),
                                          ],
                                        ))
                                      ],
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  width: 85,
                                  height: 35,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                    ),
                                    child: Text("View"),
                                    onPressed: () {
                                      _patientData
                                          .getDocsId(
                                              data[index]['patientemail'])
                                          .then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AboutScreen(
                                                            patientId: value)));
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  width: 85,
                                  height: 35,
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                    ),
                                    onPressed: () async {
                                      var docId = await _patientData.getDocsId(
                                          data[index]['patientemail']);
                                      var info = await _patientData
                                          .getPatientInfo(docId);
                                      var tele = info['phoneno'];
                                      await launch("tel:$tele");
                                    },
                                    icon: Icon(Icons.call),
                                    label: Text('Call'),
                                  ),
                                )
                              ],
                            )
                          ]));
                    }),
                  ),
                ),
              ));
  }
}
