import 'package:flutter/material.dart';
import 'product.dart';
import 'productdetail.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'payscreen.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Cart...";
  final formatter = new NumberFormat("#,##");
  String productname = "";
  String shopName;
  int numcart = 0;

  double sizing = 11.5;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          cartList == null
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
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(cartList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            child: InkWell(
                          onTap: () => _loadproductDetails(index),
                          onLongPress: () => _deleteOrderDialog(index),
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: screenHeight / 6,
                                    width: screenWidth / 4,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://yhkywy.com/petscentury/images/productimages/${cartList[index]['imagename']}.jpg",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),
                                    )),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartList[index]['productname'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("RM " +
                                        cartList[index]['productprice'] +
                                        " x " +
                                        cartList[index]['productqty'] +
                                        " set"),
                                    Text("Total RM " +
                                        (double.parse(cartList[index]
                                                    ['productprice']) *
                                                int.parse(cartList[index]
                                                    ['productqty']))
                                            .toStringAsFixed(2))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )));
                  }),
                )),
          Container(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Place order'),
              color: Colors.brown,
              textColor: Colors.white,
              elevation: 15,
              onPressed: _onplaceorder,
            ),
          ))
        ],
      ),
    ));
  }

  _loadproductDetails(int index) async {
    Product curproduct = new Product(
        productid: cartList[index]['productid'],
        productname: cartList[index]['productname'],
        productprice: cartList[index]['productprice'],
        productqty: cartList[index]['availqty'],
        productimg: cartList[index]['imagename'],
        shopid: cartList[index]['shopid'],
        productcurqty: cartList[index]['productqty']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductDetails(
                  product: curproduct,
                  user: widget.user,
                )));
    _loadCart();
  }

  void _loadCart() {
    http.post("https://yhkywy.com/petscentury/php/load_cart.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        cartList = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        numcart = 0;
        setState(() {
          var jsondata = json.decode(res.body);
          cartList = jsondata["cart"];

          shopName = cartList[0]['shopname'];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteOrderDialog(int index) {
    print("Delete " + cartList[index]['productname']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete order " + cartList[index]['productname'] + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are your sure? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteCart(index);
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

  void _deleteCart(int index) {
    http.post("https://yhkywy.com/petscentury/php/delete_cart.php", body: {
      "email": widget.user.email,
      "productid": cartList[index]['productid'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        _loadCart();
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Delete failed!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onplaceorder() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PayScreen(
                  user: widget.user,
                )));
  }
}
