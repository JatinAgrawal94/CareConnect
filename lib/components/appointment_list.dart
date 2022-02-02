import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';


class AppointmentList extends StatefulWidget {
  final String date;
  final String timing;
  final String visittype;
  final String reason;
  final String doctor;
  final String paymentstatus;
  final String paymentamount;
  final String doctoremail;
  AppointmentList(
      {Key key,
      this.date,
      this.timing,
      this.visittype,
      this.reason,
      this.doctor,
      this.doctoremail,
      this.paymentstatus,
      this.paymentamount})
      : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState(
      this.date,
      this.timing,
      this.visittype,
      this.reason,
      this.doctor,
      this.doctoremail,
      this.paymentstatus,
      this.paymentamount);
}

class _AppointmentListState extends State<AppointmentList> {
  final String date;
  final String timing;
  final String visittype;
  final String reason;
  final String doctor;
  final String doctoremail;
  final String paymentstatus;
  final String paymentamount;
  _AppointmentListState(this.date, this.timing, this.visittype, this.reason,
      this.doctor, this.doctoremail, this.paymentstatus, this.paymentamount);

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
   
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
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
            Container(
              child: Row(
                children: <Widget>[
                  Text("PaymentAmount : Rs $paymentamount",
                      style: TextStyle(fontSize: 17)),
                  paymentstatus == 'Unpaid'
                      ? Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            

                          // ElevatedButton(
                          //   child: Text(
                          //     "Pay",
                          //     style: TextStyle(fontSize: 17),
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //       primary: Colors.deepPurple),
                          //   onPressed: () {
                          //     return Fluttertoast.showToast(
                          //         msg: "Chal Paisa Nikal !",
                          //         toastLength: Toast.LENGTH_LONG,
                          //         gravity: ToastGravity.SNACKBAR,
                          //         backgroundColor: Colors.deepPurple,
                          //         textColor: Colors.white,
                          //         fontSize: 15,
                          //         timeInSecForIosWeb: 1);
                          //   },
                          // ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ));
  }
}
