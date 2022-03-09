import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';

class PhotoGridButton extends StatefulWidget {
  final List images;
  final List videos;
  final List files;
  final userId;
  final category;
  // object
  final filename;
  // type is the type of operation for button whether it can be new or old
  final String type;
  // size is the percentage of width required of the total width
  final size;
  PhotoGridButton(
      {Key key,
      this.images,
      this.videos,
      this.files,
      this.type,
      this.size,
      this.userId,
      this.category,
      this.filename})
      : super(key: key);

  @override
  State<PhotoGridButton> createState() => _PhotoGridButtonState(
      this.images,
      this.videos,
      this.files,
      this.type,
      this.size,
      this.userId,
      this.category,
      this.filename);
}

class _PhotoGridButtonState extends State<PhotoGridButton> {
  final List images;
  final List videos;
  final List files;
  final String type;
  final size;
  final userId;
  final category;
  final filename;
  // PatientData _patientData = PatientData();
  _PhotoGridButtonState(this.images, this.videos, this.files, this.type,
      this.size, this.userId, this.category, this.filename);
  @override
  void initState() {
    super.initState();
    // if (type == "records") {
    //   _patientData.getMediaURL(userId, category, 'images', filename);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PhotoGrid(
                      image: images,
                      video: videos,
                      file: files,
                      filetype: type,
                    )));
      },
      fillColor: Colors.deepPurple,
      splashColor: Colors.white,
      child: Container(
          width: MediaQuery.of(context).size.width * size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "View",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_right,
                color: Colors.white,
              )
            ],
          )),
    );
  }
}
