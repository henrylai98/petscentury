import 'package:flutter/material.dart';
import 'package:petscentury/loginscreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'user.dart';
import 'package:toast/toast.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
            body: Column(
          children: <Widget>[
            SizedBox(height:200),
            Container(
               alignment: Alignment.center,
               height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/petslogo.jpg'),
                        ))),
                        
            Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: <Widget>[
                    Opacity(opacity: 0.5),
                    Shimmer.fromColors(
                      baseColor: Colors.brown[500],
                      highlightColor: Colors.yellow,
                      child: Text(
                        'Pets Century',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 150),
                    new ProgressIndicator(),
                  ],
                )),
          ],
        )));
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
          //  controller.stop();
          //  loadpref(this.context);
              Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (BuildContext context) => LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      //width: 200,
      //color: Colors.redAccent,
      child: CircularProgressIndicator(
        value: animation.value,
        //backgroundColor: Colors.black,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
      ),
    ));
  }

   void loadpref(BuildContext ctx) async {
    print('Inside loadpref()');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? '');
    String pass = (prefs.getString('pass') ?? '');
    print("Splash:Preference" + email + "/" + pass);
    if (email.length > 5) {
      //login with email and password
      loginUser(email, pass, ctx);
    } else {
      loginUser("unregistered","123456789",ctx);
    }
  }

  void loginUser(String email, String pass, BuildContext ctx) {
   
    http.post("https://yhkywy.com/petscentury/php/login_user.php", body: {
      "email": email,
      "password": pass,
    })
        //.timeout(const Duration(seconds: 4))
        .then((res) {
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            email: email,
            name: userdata[1],
            password: pass,
            phone: userdata[2],
            date: userdata[3],
            credit: userdata[4]
            );
   
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: _user,
                    )));
      } else {
        Toast.show("Login as unregistered account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loginUser("unregistered@petscentury.com","123456789",ctx);
       }
    }).catchError((err) {
      print(err);
   
    });
  }
}
