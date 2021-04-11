import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageData {
  final ImagePicker picker = ImagePicker();
  static var image;

  Future imgfromCamera() async {
    final pickerfile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    return pickerfile;
  }

  Future imgfromgallery() async {
    final galleryimage =
        picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    return galleryimage;
  }

  PickedFile showpicker(context) {
    print("This is showPicker");
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                  child: Wrap(children: <Widget>[
            ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("PhotoGallery"),
                onTap: () {
                  var result = imgfromgallery();
                  result.then((value) {
                    image = result;
                  });
                  print("Image is $image");
                  Navigator.of(context).pop();
                  return image;
                }),
            ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("Camera"),
                onTap: () {
                  var result = imgfromCamera();
                  result.then((value) {
                    image = value;
                  });
                  Navigator.of(context).pop();
                  return image;
                }),
          ])));
        });
    return image;
  }
}
