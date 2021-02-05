import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'user.dart';
import 'package:numberpicker/numberpicker.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  final User user;

  const ProductDetails({Key key, this.product, this.user}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double screenHeight, screenWidth;
  int selectedQty = 0;


  @override
  void initState() {
    super.initState();
    selectedQty = int.parse(widget.product.productcurqty) ?? 1;
  
  }

  @override
  Widget build(BuildContext context) {
    var productQty =
        Iterable<int>.generate(int.parse(widget.product.productqty) + 1).toList();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(widget.product.productname),
        ),
        body: Container(
          color: Color(0xFFFFF3E0),
            child: Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Color(0xFFFFF3E0),
                          height: screenHeight / 2.8,
                          width: screenWidth / 0.1,
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://yhkywy.com/petscentury/images/productimages/${widget.product.productimg}.jpg",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,
                            ),
                          )),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Select Quantity"),
                          SizedBox(width: 10),
                          NumberPicker.horizontal(
                            decoration: BoxDecoration(
                              border: new Border(
                                top: new BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black26,
                                ),
                                bottom: new BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                            initialValue: selectedQty,
                            minValue: 1,
                            maxValue: productQty.length - 1,
                            step: 1,
                            zeroPad: false,
                            onChanged: (value) =>
                                setState(() => selectedQty = value),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(children: [
                      Text("Price RM " 
                         ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Text(
                          (selectedQty * double.parse(widget.product.productprice))
                              .toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red,fontSize: 20),),],),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add to Cart'),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onOrderDialog,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )));
  }

  void _onOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Order " + widget.product.productname + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Quantity " + selectedQty.toString(),
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
              onPressed: () {
                Navigator.of(context).pop();
                _orderproduct();
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

  void _orderproduct() {  
   
    http.post("https://yhkywy.com/petscentury/php/insert_cart.php", body: {
      "email": widget.user.email,
      "productid": widget.product.productid,
      "productqty": selectedQty.toString(),
      "shopid": widget.product.shopid,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
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
}