import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'product.dart';
import 'shop.dart';
import 'package:http/http.dart' as http;
import 'productdetail.dart';
import 'cartscreen.dart';
import 'user.dart';

class ShopDetails extends StatefulWidget {
  final Shop shop;
  final User user;

  const ShopDetails({Key key, this.shop, this.user}) : super(key: key);

  @override
  _ShopDetailsState createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  double screenHeight, screenWidth;
  List productList;
  String titlecenter = "Loading products...";
  String type = "Food";
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    _loadproducts(type);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(widget.shop.shopname),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              _shoppinCartScreen();
            },
          )
        ],
      ),
      body: Column(children: [
        Container(
            height: screenHeight / 2.8,
            width: screenWidth / 0.3,
            child: CachedNetworkImage(
              imageUrl:
                  "http://yhkywy.com/petscentury/images/shopimages/${widget.shop.shopimage}.jpg",
              fit: BoxFit.cover,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(
                Icons.broken_image,
                size: screenWidth / 2,
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.food_bank),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      type = "Food";
                      _loadproducts(type);
                    });
                  },
                ),
                Text(
                  "Food",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.toys),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      type = "Toy";
                      _loadproducts(type);
                    });
                  },
                ),
                Text(
                  "Toys",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
             Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.cleaning_services),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      type = "Grooming";
                      _loadproducts(type);
                    });
                  },
                ),
                Text(
                  "Groom",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            
          ],
        ),
        Text("Available $type "),
        Divider(
          color: Colors.grey,
        ),
        productList == null
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
                child: RefreshIndicator(
                    key: refreshKey,
                    color: Colors.red,
                    onRefresh: () async {
                      _loadproducts(type);
                    },
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.62,
                      children: List.generate(productList.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(2),
                            child: Card(
                                child: InkWell(
                              onTap: () => _loadproductDetails(index),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      color: Color(0xFFFFF3E0),
                                        height: screenHeight / 5,
                                        width: screenWidth / 1.2,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://yhkywy.com/petscentury/images/productimages/${productList[index]['imagename']}.jpg",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(
                                            Icons.broken_image,
                                            size: screenWidth / 2,
                                          ),
                                        )),
                                    SizedBox(height: 5),
                                    Column(children: [
                                    Text(
                                      productList[index]['productname'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    
                                    Text("Quantity available:" +
                                        productList[index]['productqty']),
                                    Text("RM " +
                                        productList[index]['productprice'], style: TextStyle(
                                          fontSize: 15, color:Colors.red,
                                          fontWeight: FontWeight.bold), ),
                                     
                                        ],),
                                  ],
                                ),
                              ),
                            )));
                      }),
                    )),
              )
      ]),
    );
  }

  void _shoppinCartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CartScreen(user: widget.user)));
  }

  Future<void> _loadproducts(String ptype) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://yhkywy.com/petscentury/php/load_products.php", body: {
      "shopid": widget.shop.shopid,
      "producttype":ptype,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        productList = null;
        setState(() {
          titlecenter = "No $type Available";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          productList = jsondata["products"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadproductDetails(int index) {
    Product product = new Product(
        productid: productList[index]['productid'],
        productname: productList[index]['productname'],
        productprice: productList[index]['productprice'],
        productqty: productList[index]['productqty'],
        productimg: productList[index]['imagename'],
        productcurqty: "1",
        shopid: widget.shop.shopid);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductDetails(
                  product: product,
                  user: widget.user,
                )));
                _loadproducts(type);
  }
}