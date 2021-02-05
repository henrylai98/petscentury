import 'package:flutter/material.dart';
import 'package:petscentury/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'user.dart';
import 'package:petscentury/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


class LoginScreen extends StatefulWidget {
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
bool _rememberMe = false;
  String _email = "";
  String _password = "";

  double screenHeight, screenWidth;
  SharedPreferences prefs;

  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color(0xFF3E2723),
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                child: ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250.0,
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/login.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(children: <Widget>[
                      SizedBox(width: 50),
                      Container(
                        child:
                            Icon(Icons.pets, size: 70, color: Colors.brown[50]),
                      ),
                      SizedBox(width: 10),
                      Text('Sign In',
                          style: GoogleFonts.ranchers(
                              textStyle: TextStyle(
                                  fontSize: 50, color: Colors.brown[50]))),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: BorderSide(
                                color: Colors.brown[50],
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: BorderSide(
                                color: Colors.brown[50],
                              ),
                            ),
                            hintText: "Enter Email Address",
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.brown[50],
                            ),
                            labelStyle: TextStyle(
                              color: Colors.brown[50],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: TextField(
                        controller: _passController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: BorderSide(
                                color: Colors.brown[50],
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: BorderSide(
                                color: Colors.brown[50],
                              ),
                            ),
                            hintText: "Enter Password",
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.brown[50],
                            ),
                            labelStyle: TextStyle(color: Colors.brown[50])),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(children: [
                        SizedBox(
                          height: 20,
                          width: 130,
                        ),
                        GestureDetector(
                            onTap: _forgotPass,
                            child: Text('Forgot Password?',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.brown[50]))),
                      ]),
                    ),
                    SizedBox(height: 10),
                    Row(children: <Widget>[
                      Theme(
                        data:
                            ThemeData(unselectedWidgetColor: Colors.brown[50]),
                        child: Checkbox(
                          value: _rememberMe,
                           activeColor: Colors.brown[50],
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                      ),
                      Text('Remember Me',
                          style:
                              TextStyle(fontSize: 16, color: Colors.brown[50]))
                    ]),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minWidth: 200,
                      height: 60,
                      child: Text('LOGIN'),
                      color: Colors.brown[50],
                      textColor: Colors.brown,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                    SizedBox(height: 50),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Dont have an Account?',
                          style: TextStyle(color: Colors.brown[50])),
                      SizedBox(width: 5),
                      GestureDetector(
                          onTap: _onRegister,
                          child: Text('Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.brown[50]))),
                    ]),
                  ],
                )),
              ),
            ]))));
  }

  _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  _onNext(String email) {
    String _email = email;
    TextEditingController newpassController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.brown[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "New Credential",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 23,
                ),
              ),
              content: SizedBox(
                height: 100,
                child: new Column(children: <Widget>[
                  Text(
                    ' Pleases type your new password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[300],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: newpassController,
                    decoration: InputDecoration(
                        labelText: "New Password",
                        labelStyle: TextStyle(color: Colors.brown),
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
                        hintText: "Enter New Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.brown,)),
                    obscureText: true,
                  ),
                ]),
              ),
              actions: [
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minWidth: 50,
                    height: 40,
                    child: Text('RESET MY PASSWORD'),
                    color: Colors.brown,
                    textColor: Colors.white,
                    elevation: 15,
                    onPressed: () {
                      _onReset(
                        _email,
                        newpassController.text,
                      );
                    }),
              ]);
        });
  }

  void _onChange(bool value) => setState(() {
        _rememberMe = value;
        if (_rememberMe) {
          savePref(true);
        }  else {
          savePref(false);
        }
      });

  _forgotPass() {
    TextEditingController emailController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Forgot Password?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 23,
                ),
              ),
              content: SizedBox(
                  height: 100,
                  child: Column(children: <Widget>[
                    Text(
                      'Please enter your email address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[300],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email,color: Colors.brown,),
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
                          hintText: "Enter Email Addess",
                        )),
                  ])),
              actions: [
                Center(
                    child: Row(
                  children: [
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        minWidth: 50,
                        height: 40,
                        child: Text('NEXT'),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: () {
                          _onNext(emailController.text);
                        }),
                    SizedBox(width: 10),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minWidth: 50,
                      height: 40,
                      child: Text('CANCEL'),
                      color: Colors.brown,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onCancel,
                    ),
                  ],
                ))
              ]);
        });
  }

  _onCancel() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  Future<void> _onReset(
    String ownemail,
    String newpassword,
  ) async {
    http.post("https://yhkywy.com/petscentury/php/resetpass.php", body: {
      "email": ownemail,
      "newpassword": newpassword,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Password updated",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      } else {
        Toast.show(
          "Password fail to update",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _onLogin() async {
    _email = _emailController.text;
    _password = _passController.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://yhkywy.com/petscentury/php/login_user.php", body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      print(res.body);
      List userdata = res.body.split(",");
      if (userdata[0] == "success") {
        Toast.show(
          "Login success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        User user = new User(
            email: _email,
            name: userdata[1],
            password: _password,
            phone: userdata[2],
            date: userdata[3],
            credit: userdata[4]);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(
             user: user
            )));
      } else {
        Toast.show(
          "Login fail",
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

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberMe')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emailController.text = _email;
        _passController.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }

  void savePref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emailController.text;
    _password = _passController.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("Invalid Email or Password");
        _rememberMe = false;
        Toast.show(
          "Invalid Email or Password",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberMe', value);
        Toast.show("Saved", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print('Preferences Saved');
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberMe', false);
      setState(() {
        _emailController.text = '';
        _passController.text = '';
        _rememberMe = false;
      });
      Toast.show("Preferences removed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
