// import 'dart:io';
// import 'package:flutter/material.dart';


// class DateTimeWidget {
//   Future<Null> _selectDate(BuildContext context,DateTime selectedDate) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         initialDatePickerMode: DatePickerMode.day,
//         firstDate: DateTime(2015),
//         lastDate: DateTime(2101));
//     if (picked != null)
//       setState(() {
//         selectedDate = picked;
//         _dateController.text = DateFormat.yMd().format(selectedDate);
//       });
//   }
// }
