import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:petscentury/storecredit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'loginscreen.dart';
import 'registerscreen.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String server = "https://yhkywy.com/petscentury";
  double screenHeight, screenWidth;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
    print("profile screen");
    // DefaultCacheManager manager = new DefaultCacheManager();
    // manager.emptyCache();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    parsedDate = DateTime.parse(widget.user.date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Card(
              //color: Colors.red,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            height: screenHeight / 4.8,
                            width: screenWidth / 3.2,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              //border: Border.all(color: Colors.black),
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: 
                                  "http://yhkywy.com/petscentury/images/profileimages/${widget.user.email}.jpg?",
                              placeholder: (context, url) => new SizedBox(
                                  height: 10.0,
                                  width: 10.0,
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  new Icon(MdiIcons.cameraIris, size: 64.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Container(
                          // color: Colors.red,
                          child: Table(
                              defaultColumnWidth: FlexColumnWidth(1.0),
                              columnWidths: {
                                0: FlexColumnWidth(3.5),
                                1: FlexColumnWidth(6.5),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Text("Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(widget.user.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.brown)),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Text("Email",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(widget.user.email,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.brown)),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Text("Phone",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(widget.user.phone,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.brown)),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Text("Register Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(f.format(parsedDate),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.brown)),
                                    ),
                                  ),
                                ]),
                              ]),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Divider(
                      height: 2,
                      color: Colors.brown,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "Store Credit",
                              style: TextStyle(color: Colors.brown),
                            ),
                            Text(widget.user.credit,
                                style: TextStyle(
                                    color: Colors.brown))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.brown,
              child: Center(
                child: Text("SET YOUR PROFILE",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown)),
              ),
            ),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            Expanded(

                //color: Colors.red,
                child: ListView(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    shrinkWrap: true,
                    children: <Widget>[
                  MaterialButton(
                    onPressed: changeName,
                    child: Text("CHANGE YOUR NAME"),
                  ),
                  MaterialButton(
                    onPressed: changePassword,
                    child: Text("CHANGE YOUR PASSWORD"),
                  ),
                  MaterialButton(
                    onPressed: changePhone,
                    child: Text("CHANGE YOUR PHONE"),
                  ),
                  MaterialButton(
                    onPressed: _gotologinPage,
                    child: Text("GO LOGIN SCREEN"),
                  ),
                  MaterialButton(
                    onPressed: _registerAccount,
                    child: Text("REGISTER NEW ACCOUNT"),
                  ),
                  MaterialButton(
                    onPressed: buyStoreCredit,
                    child: Text("BUY STORE CREDIT"),
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  void _takePicture() async {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    File _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 300);
    //print(_image.lengthSync());
    if (_image == null) {
      Toast.show("Please take image first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      print(base64Image);
      http.post(server + "/php/upload_image.php", body: {
        "encoded_string": base64Image,
        "email": widget.user.email,
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
          });
        } else {
          Toast.show("fail", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void changeName() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your name?",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.brown,
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(
                      Icons.person,
                      color: Colors.brown,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.brown,
                      ),
                    ),
                    onPressed: () =>
                        _changeName(nameController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changeName(String name) {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (name == "" || name == null) {
      Toast.show("Please enter your new name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ReCase rc = new ReCase(name);
    print(rc.titleCase.toString());
    http.post(server + "/php/resetpass.php", body: {
      "email": widget.user.email,
      "name": rc.titleCase.toString(),
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.name = rc.titleCase;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePassword() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController passController = TextEditingController();
    TextEditingController pass2Controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your password?",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      style: TextStyle(
                        color: Colors.brown,
                      ),
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.brown,
                        ),
                      )),
                  TextField(
                      style: TextStyle(
                        color: Colors.brown,
                      ),
                      obscureText: true,
                      controller: pass2Controller,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.brown,
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.brown,
                      ),
                    ),
                    onPressed: () => updatePassword(
                        passController.text, pass2Controller.text)),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  updatePassword(String pass1, String pass2) {
    if (pass1 == "" || pass2 == "") {
      Toast.show("Please enter your password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(server + "/php/resetpass.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pass2;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePhone() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController phoneController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your phone number?",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.brown,
                  ),
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'New Phone Number',
                    icon: Icon(
                      Icons.phone,
                      color: Colors.brown,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.brown,
                      ),
                    ),
                    onPressed: () =>
                        _changePhone(phoneController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changePhone(String phone) {
    if (phone == "" || phone == null || phone.length < 9) {
      Toast.show("Please enter your new phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post(server + "/php/resetpass.php", body: {
      "email": widget.user.email,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.phone = phone;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void _gotologinPage() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Go to login page?",
            style: TextStyle(
              color: Colors.brown,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.brown,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.brown,
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

  void _registerAccount() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Register new account?",
            style: TextStyle(
              color: Colors.brown,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.brown,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.brown,
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

  void buyStoreCredit() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController creditController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Buy Store Credit?",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.brown,
                  ),
                  controller: creditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter RM',
                    icon: Icon(
                      Icons.attach_money,
                      color: Colors.brown,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.brown,
                      ),
                    ),
                    onPressed: () =>
                        _buyCredit(creditController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _buyCredit(String cr) {
    print("RM " + cr);
    if (cr.length <= 0) {
      Toast.show("Please enter correct amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buy store credit RM ' + cr,
          style: TextStyle(
            color: Colors.brown,
          ),
        ),
        content: new Text(
          'Are you sure?',
          style: TextStyle(
            color: Colors.brown,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
                Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => StoreCreditScreen(
                  user: widget.user,
                  val: cr,
                )));
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.brown,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.brown,
                ),
              )),
        ],
      ),
    );
  }
}
