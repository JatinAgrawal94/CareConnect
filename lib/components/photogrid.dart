import 'package:careconnect/components/displaypdf.dart';
import 'package:careconnect/components/displayphoto.dart';
import 'package:careconnect/components/displayvideo.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';
class PhotoGrid extends StatefulWidget {
  final List image;
  final List video;
  final List file;
  PhotoGrid({Key key, this.image, this.video, this.file}) : super(key: key);

  @override
  State<PhotoGrid> createState() =>
      _PhotoGridState(this.image, this.video, this.file);
}

class _PhotoGridState extends State<PhotoGrid> {
  List image = [];
  List video = [];
  List file = [];
  List videoThumbnails = [];
  _PhotoGridState(this.image, this.video, this.file);
  PatientData _patientData = PatientData();
  @override
  void initState() {
    super.initState();
    _patientData.getVideoThumbnail(video).then((value) {
      setState(() {
        videoThumbnails = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Media"),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          image.length != 0
              ? Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  decoration: BoxDecoration(color: Colors.deepPurpleAccent),
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text("Images",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
              : Text(""),
          image.length != 0
              ? Container(
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 3),
                      itemCount: image.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DisplayPhoto(
                                            image: image[index]['filename'],
                                            name: image[index]['name'],
                                          )));
                            },
                            child: Container(
                                height: 200,
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.file(
                                      image[index]['filename'],
                                      width: 100,
                                      height: 100,
                                    ),
                                    Expanded(
                                        child: Text(image[index]['name'],
                                            maxLines: 3,
                                            textAlign: TextAlign.center))
                                  ],
                                )));
                      }),
                )
              : Text(""),
          video.length != 0
              ? Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: BoxDecoration(color: Colors.deepPurpleAccent),
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text("Videos",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
              : Text(""),
          video.length != 0
              ? Container(
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 3),
                      itemCount: videoThumbnails.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DisplayVideo(
                                            video: video[index]['filename'],
                                          )));
                            },
                            child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                                width: 100,
                                height: 120,
                                child: Column(
                                  children: [
                                    Image.memory(videoThumbnails[index],
                                        width: 100, height: 100),
                                    Expanded(
                                        child: Text(video[index]['name'],
                                            maxLines: 2,
                                            textAlign: TextAlign.center))
                                  ],
                                )));
                      }),
                )
              : Text(""),
          file.length != 0
              ? Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: BoxDecoration(color: Colors.deepPurpleAccent),
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text("Files",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
              : Text(""),
          file.length != 0
              ? Container(
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 3),
                      itemCount: file.length,
                      itemBuilder: (context, index) {
                        return new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DisplayPdf(
                                            file: file[index]['filename'],
                                          )));
                            },
                            child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.attachment,
                                      size: 100,
                                    ),
                                    Expanded(
                                        child: Text(file[index]['name'],
                                            maxLines: 2,
                                            textAlign: TextAlign.center))
                                  ],
                                )));
                      }),
                )
              : Text(""),
        ]))));
  }
}
