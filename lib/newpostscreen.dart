import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'post.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'user.dart';
import 'postscreen.dart';

class NewPostScreen extends StatefulWidget {
  final Post post;
  final User user;

  const NewPostScreen({Key key, this.post, this.user}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  double screenHeight, screenWidth;
  File _image;
  String _story= " ";
  final TextEditingController _storycontroller = TextEditingController();

 

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text("New Post"),
        ),
        body: Container(
          color: Color(0xFFFFF3E0),
            child: Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
               
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () => {_onPictureSelection()},
                          child: Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: _image == null
                                    ? AssetImage("assets/images/camera.jpg")
                                    : FileImage(_image),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                width: 3.0,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5.0) //         <--- border radius here
                                  ),
                            ),
                          )),
                      SizedBox(height: 5),
                      Text("Click image to take picture",
                          style:
                              TextStyle(fontSize: 10.0, color: Colors.black)),
                      SizedBox(height: 10),
                      TextField(
                          controller: _storycontroller,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          decoration: InputDecoration(
                              labelText: 'Your Pet Story',
                              icon: Icon(Icons.notes))),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('post'),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onPostDialog,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )));
  }

  void _onPostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Continue to post?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                 _addPost();
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PostScreen(
                                  user: widget.user

                                )));
               
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
void _addPost() {
    final dateTime = DateTime.now();
    _story = _storycontroller.text;
    
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("https://yhkywy.com/petscentury/php/addnewpost.php", body: {
      "email": widget.user.email,
      "name": widget.user.name,
      "story": _story,
      "encoded_string": base64Image,
      "postimage": widget.user.email + "-${dateTime.microsecondsSinceEpoch}",

    }).then((res) {
      print(res.body);
      if (res.body == "succes") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
       
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.blueGrey,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.blueGrey,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
}
