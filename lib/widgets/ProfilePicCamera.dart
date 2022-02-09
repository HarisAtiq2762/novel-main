import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicCamera extends StatefulWidget {
  @override
  _ProfilePicCameraState createState() => _ProfilePicCameraState();
}

class _ProfilePicCameraState extends State<ProfilePicCamera> {
  File imageProfile;

  Future _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imageProfile = File(pickedFile.path);
    });
  }

  Future _imgFromGallery() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageProfile = File(pickedFile.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library_outlined),
                  title: Text('Photo Gallery'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera_outlined),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: Center(
        child: CircleAvatar(
          child: Icon(
            Icons.photo_camera_outlined,
            size: 46,
            color: Colors.red,
          ),
          radius: 46,
          backgroundImage: imageProfile == null
              ? AssetImage('asset/pic1.jpg')
              : Image.file(
            imageProfile,
            fit: BoxFit.cover,
          ).image,
        ),
      ),
    );
  }
}
