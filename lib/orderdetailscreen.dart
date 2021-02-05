  
import 'dart:convert';
import 'package:flutter/material.dart';
import 'order.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:intl/intl.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  const OrderDetail({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  List _orderdetails;
  String titlecenter = "Loading order details";
  double screenHeight, screenWidth;


  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Order Details',style: TextStyle(color:Colors.white),),
      ),
      body: Container(
        
        child: Column(children: <Widget>[
          _orderdetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      itemCount:
                          _orderdetails == null ? 0 : _orderdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                  color: Colors.brown[100],
                                    elevation: 8,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child:Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                (index + 1).toString()+'.',
                                                style: TextStyle(
                                                    color: Colors.pink,fontWeight: FontWeight.bold),
                                              )),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: 
                                                      "http://yhkywy.com/petscentury/images/productimages/${_orderdetails[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              _orderdetails[index]['name'],
                                              style: TextStyle(
                                                  color: Colors.pink,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                         Expanded(
                                            flex: 1,
                                            child: Text(
                                              _orderdetails[index]['quantity'],
                                              style: TextStyle(
                                                  color: Colors.pink,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                    ))));
                      }))
        ]),
      ),
    );
  }

  _loadOrderDetails() async {
    String urlLoadJobs = "https://yhkywy.com/petscentury/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "billid": widget.order.billid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}