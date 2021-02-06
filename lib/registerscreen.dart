import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:petscentury/loginscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';



class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final RegExp phoneRegex = new RegExp(r'^[0-9]*$');
  final RegExp passRegex =
      new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String _name = "";
  String _email = "";
  String _phone = "";
  String _password = "";
  bool _passwordVisible = false;
  bool _isChecked = false;
  bool _rememberMe = false;
  File _image;

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            color: Color(0xFFFFF3E0),
            child: SingleChildScrollView(
                child: Column(children: [
                   
              Container(
                child: ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250.0,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/login.png'),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () => {_onPictureSelection()},
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage('assets/images/camera.jpg')
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
              Text("Click image to take profile picture",
                  style: TextStyle(fontSize: 10.0, color: Colors.black)),
              
              Padding(
                  padding: EdgeInsets.all(40),
                  child: SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 30),
                                  Container(
                                    child: Icon(Icons.pets,
                                        size: 70, color: Colors.brown),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Sign Up',
                                      style: GoogleFonts.ranchers(
                                          textStyle: TextStyle(
                                        fontSize: 50,
                                        color: Colors.brown,
                                      ))),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Enter Firstname",
                                      labelText: "Name",
                                      labelStyle: TextStyle(
                                        color: Colors.brown,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.brown,
                                      )),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                      color: Colors.brown,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.brown,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                      ),
                                    ),
                                    hintText: "Enter Email Address",
                                  ),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Please enter some text';
                                    } else if (!EmailValidator.validate(
                                        val, true)) {
                                      return 'Not a valid email.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (val) => _email = val,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: "Phone No",
                                    labelStyle: TextStyle(
                                      color: Colors.brown,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.brown,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                      ),
                                    ),
                                    hintText: "Enter Phone Number",
                                  ),
                                  validator: (_phone) {
                                    if (_phone.isEmpty) {
                                      return 'Please enter some text';
                                    } else if (!phoneRegex.hasMatch(_phone)) {
                                      return 'Please enter valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  controller: _passController,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    helperText:
                                        '*Minimum of 8 characters,at least 1 letter & 1 number',
                                    labelStyle: TextStyle(
                                      color: Colors.brown,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                      ),
                                    ),
                                    hintText: "Enter Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.brown,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.brown,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variablegithu
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (_pass) {
                                    if (_pass.isEmpty) {
                                      return 'Please enter some text';
                                    } else if (!passRegex.hasMatch(_pass)) {
                                      return 'Please enter valid password';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) => _password = val.trim(),
                                  obscureText: _passwordVisible,
                                ),
                              ),
                              
                              Column(children: [
                                Row(children: <Widget>[
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Colors.brown),
                                    child: Checkbox(
                                      value: _isChecked,
                                      activeColor: Colors.brown,
                                      onChanged: (bool value) {
                                        _onChange(value);
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _showEULA,
                                    child: Row(
                                      children: <Widget>[
                                        Text('I Accept the Terms of ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.brown,
                                            )),
                                        Text('EULA',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.brown,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Colors.brown),
                                    child: Switch(
                                      activeColor: Colors.brown,
                                      activeTrackColor: Colors.brown,
                                      inactiveTrackColor: Colors.brown[100],
                                      value: _rememberMe,
                                      onChanged: (bool value) {
                                        _onSwitch(value);
                                      },
                                    ),
                                  ),
                                  Text('Remember Me',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.brown,
                                      )),
                                ]),
                              ]),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                minWidth: 200,
                                height: 60,
                                child: Text('SIGN UP'),
                                color: Colors.brown,
                                textColor: Colors.brown[50],
                                elevation: 15,
                                onPressed: _onSignup,
                              ),
                              SizedBox(height: 100),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Have an Account?',
                                        style: TextStyle(
                                          color: Colors.brown,
                                        )),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                        onTap: _onLogin,
                                        child: Text('Sign in',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.brown,
                                            ))),
                                  ]),
                            ],
                          ))))
            ]))));
  }

  void _dialog() {
    if (_image == null) {
      Toast.show("Please set your profile picture.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.brown[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text("Continue Registration?",
                  style: TextStyle(color: Colors.brown[50])),
              content: new Row(children: <Widget>[
                SizedBox(width: 20),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minWidth: 80,
                  height: 30,
                  child: Text('Yes'),
                  color: Colors.yellowAccent,
                  textColor: Colors.black,
                  elevation: 15,
                  onPressed: _onRegister,
                ),
                SizedBox(width: 40),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minWidth: 80,
                  height: 30,
                  child: Text('No'),
                  color: Colors.yellowAccent,
                  textColor: Colors.black,
                  elevation: 15,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]));
        });
  }

  void _onSignup() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      _dialog();
    }
  }

  void _onRegister() async {
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      _name = _nameController.text;
      _email = _emailController.text;
      _phone = _phoneController.text;
      _password = _passController.text;
      final dateTime = DateTime.now();
      String base64Image = base64Encode(_image.readAsBytesSync());
      print(base64Image);
      
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration...");
      await pr.show();
      http.post("https://yhkywy.com/petscentury/php/register_user.php", body: {
        "name": _name,
          "email": _email,
          "password": _password,
          "phone": _phone,
          "encoded_string": base64Image,
           "imagename": _phone + "-${dateTime.microsecondsSinceEpoch}",
          
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          Toast.show(
            "Registration success. Please check your email for OTP verification.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
        
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
        } else {
          Toast.show(
            "Registration failed",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
        }
      }).catchError((err) {
        print(err);
      });
      await pr.hide();
    }
  }

  _onLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _onSwitch(bool value) {
    setState(() {
      _rememberMe = value;
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


  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Pets Century Android App \n***End-User License Agreement*** \nLast Updated: December 12, 2020",
              style: TextStyle(fontSize: 20)),
          content: new Container(
            height: 300,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                          text:
                              "This End-User License Agreement is a legal agreement between you and Lai Yip Hang \n\nThis EULA agreement governs your acquisition and use of our Pets Century software (Software) directly from Lai Yip Hang or indirectly through Lai Yip Hang authorized reseller or distributor (a Reseller).\nPlease read this EULA agreement carefully before completing the installation process and using the Pets Century software. It provides a license to use the Pets Century software and contains warranty information and liability disclaimers. \n\nIf you register for a free trial of the Pets Century software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the Pets Century software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. \n\nIf you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\n\nThis EULA agreement shall apply only to the Software supplied by Lai Yip Hang herewith regardless of whether other software is referred to or described herein. The terms also apply to any Lai Yip Hang updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Pets Century. Lai Yip Hang shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made there to) are and shall remain the property of Lai Yip Hang. Lai Yip Hang reserves the right to grant licences to use the Software to third parties.",
                        )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}


class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 10, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 10), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

