import 'package:flutter/material.dart';
import 'dart:io';

class DisplayPhoto extends StatelessWidget {
  final File image;
  final String name;

  DisplayPhoto({Key key, this.image, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          
          AspectRatio(
            aspectRatio: 1,
            child: Container(width: double.infinity, child: Image.file(image)),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
