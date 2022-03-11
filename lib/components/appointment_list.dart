import 'package:careconnect/services/general.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentList extends StatefulWidget {
  final String date;
  final String timing;
  final String visittype;
  final String reason;
  final String doctor;
  final String paymentstatus;
  final String paymentamount;
  final String doctoremail;
  final String patientemail;
  final String appointmenttype;
  final String zoomlink;

  AppointmentList({
    Key key,
    this.date,
    this.timing,
    this.visittype,
    this.reason,
    this.doctor,
    this.doctoremail,
    this.paymentstatus,
    this.paymentamount,
    this.appointmenttype,
    this.patientemail,
    this.zoomlink,
  }) : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState(
        this.date,
        this.timing,
        this.visittype,
        this.reason,
        this.doctor,
        this.doctoremail,
        this.paymentstatus,
        this.paymentamount,
        this.appointmenttype,
        this.patientemail,
        this.zoomlink,
      );
}

class _AppointmentListState extends State<AppointmentList> {
  final String date;
  final String timing;
  final String visittype;
  final String reason;
  final String doctor;
  final String doctoremail;
  final String patientemail;
  final String paymentstatus;
  final String paymentamount;
  final String appointmenttype;
  final String zoomlink;

  _AppointmentListState(
    this.date,
    this.timing,
    this.visittype,
    this.reason,
    this.doctor,
    this.doctoremail,
    this.paymentstatus,
    this.paymentamount,
    this.appointmenttype,
    this.patientemail,
    this.zoomlink,
  );

  GeneralFunctions general = GeneralFunctions();
  List data = [];
  @override
  void initState() {
    super.initState();
    general.getDocsId(patientemail, 'Patient').then((value) {
      setState(() => {
            data.add({'userid': value['userId'], 'phone': value['phoneno']})
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$date",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "$timing",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "VisitType: $visittype",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "AppointmentType: $appointmenttype",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "Doctor: $doctor",
                      style: TextStyle(fontSize: 17),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "PaymentStatus : ",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                              text: paymentstatus,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: paymentstatus == 'Unpaid'
                                      ? Colors.red
                                      : Colors.green))
                        ])),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "Reason:$reason",
                    style: TextStyle(fontSize: 17),
                    maxLines: 20,
                  ),
                )
              ],
            ),
            appointmenttype == 'Online'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          "Zoom Meeting:$zoomlink",
                          style: TextStyle(fontSize: 17),
                          maxLines: 20,
                        ),
                      )
                    ],
                  )
                : Container(),
            Container(
              child: Row(
                children: <Widget>[
                  Text("PaymentAmount : Rs $paymentamount",
                      style: TextStyle(fontSize: 17)),
                  paymentstatus == 'Unpaid'
                      ? Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: Text(
                              "Pay",
                              style: TextStyle(fontSize: 17),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple),
                            onPressed: () async {
                              var _url =
                                  'https://careconnect-api.herokuapp.com/payment/pay?amount=$paymentamount&customerid=' +
                                      data[0]['userid'] +
                                      '&patientemail=$patientemail&phone=' +
                                      data[0]['phone'] +
                                      '&doctoremail=$doctoremail' +
                                      '&date=$date' +
                                      '&timing=$timing';

                              if (!await launch(_url)) {
                                throw 'Could not launch $_url';
                              } else {
                                print("Success");
                              }
                            },
                          ),
                        )
                      : Container(),
                  IconButton(
                      onPressed: () {},
                      icon:
                          Icon(Icons.delete_rounded, color: Colors.deepPurple))
                ],
              ),
            )
          ],
        ));
  }
}
