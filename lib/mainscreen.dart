import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'shop.dart';
import 'package:toast/toast.dart';
import 'package:petscentury/shopdetail.dart';
import 'package:petscentury/profilescreen.dart';
import 'package:petscentury/paymenthistoryscreen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:petscentury/postscreen.dart';
import 'user.dart';
import 'cartscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({
    Key key,
    this.user,
  }) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List shopList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Shop...";
  bool _visible = false;
  String selectedLoc = "Bercham";
  String selectedRating = "Highest";
  var locList = {"Bercham", "Tasek", "Kampar"};
  var ratingList = {"Highest", "Lowest"};

  @override
  void initState() {
    super.initState();
    _loadShop();
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/p1.jfif'),
          AssetImage('assets/images/p2.jfif'),
          AssetImage('assets/images/p3.jfif'),
          AssetImage('assets/images/p4.jfif'),
          AssetImage('assets/images/p5.jfif'),
        ],
        autoplay: true,
      ),
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _pncontroller = TextEditingController();

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            backgroundColor: Colors.brown,
            actions: <Widget>[
              Container(
                  width: screenWidth / 2.2,
                  padding: EdgeInsets.fromLTRB(3, 10, 1, 10),
                  child: TextField(
                    autofocus: false,
                    controller: _pncontroller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      
                    ),
                  )),
              SizedBox(width: 5),
              Flexible(
                child: IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 24,
                  onPressed: () {
                    _loadSearchFood(
                        selectedLoc, selectedRating, _pncontroller.text);
                  },
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: Icon(Icons.refresh),
                  iconSize: 24,
                  onPressed: () {
                    _loadShop();
                  },
                ),
              ),
             

              //
            ],
          ),
          
          body: Container(
            color: Color(0xFFFFF3E0),
            child: Column(
            children: <Widget>[
              //Divider(color: Colors.grey),
              image_carousel,
              Divider(color: Colors.grey),
              shopList == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))))
                  : Flexible(
                      child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.65,
                      children: List.generate(shopList.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                                child: InkWell(
                              onTap: () => _loadShopDetail(index),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                        height: screenHeight / 4.5,
                                        width: screenWidth / 1.2,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://yhkywy.com/petscentury/images/shopimages/${shopList[index]['shopimage']}.jpg",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(
                                            Icons.broken_image,
                                            size: screenWidth / 2,
                                          ),
                                        )),
                                    Text(shopList[index]['shopname'],style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                    Text(shopList[index]['shopphone']),
                                    Text(shopList[index]['shoplocation']),
                                  ],
                                ),
                              ),
                            )));
                      }),
                    ))
            ],
          ),),
        ));
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
             decoration: BoxDecoration(
    color:Colors.brown,
  ),
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[
              Text("RM " + widget.user.credit,
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              
              backgroundImage: NetworkImage(
                  "http://yhkywy.com/petscentury/images/profileimages/${widget.user.email}.jpg?"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen(
                            user: widget.user,
                          )))
            },
          ),
          ListTile(
              title: Text(
                "Shopping Cart",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                  }),
          ListTile(
              title: Text(
                "Post",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PostScreen(
                                  user: widget.user,
                                )))
                  }),
          ListTile(
              title: Text(
                "Payment History",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: _paymentScreen),
          ListTile(
              title: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfileScreen(
                                  user: widget.user,
                                )))
                  }),
        ],
      ),
    );
  }

  gotoCart() async {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
    }
  }

  void _paymentScreen() {
    if (widget.user.email == "unregistered@grocery.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistoryScreen(
                  user: widget.user,
                )));
  }

  Future<void> _loadShop() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://yhkywy.com/petscentury/php/load_shop.php", body: {
      "location": "Bercham",
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        shopList = null;
        setState(() {
          titlecenter = "No Shop Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          shopList = jsondata["shop"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  _loadShopDetail(int index) {
    print(shopList[index]['shopname']);
    Shop shop = new Shop(
        shopid: shopList[index]['shopid'],
        shopname: shopList[index]['shopname'],
        shoplocation: shopList[index]['shoplocation'],
        shopphone: shopList[index]['shopphone'],
        shopimage: shopList[index]['shopimage'],
        shopradius: shopList[index]['shopradius'],
        shoplatitude: shopList[index]['shoplatitude'],
        shoplongitude: shopList[index]['shoplongitude'],
        shopdelivery: shopList[index]['shopdelivery']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ShopDetails(
                  shop: shop,
                  user: widget.user,
                )));
  }

  _loadSearchFood(String loc, String rat, String pname) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://yhkywy.com/petscentury/php/load_shop.php", body: {
      "location": loc,
      "rating": rat,
      "productname": pname
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        shopList = null;
        setState(() {
          titlecenter = "No Restaurant Found";
        });
        Toast.show(
          "Search found no result",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          shopList = jsondata["shop"];
          Toast.show(
            "Product search found in the following shop/s",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }
}
