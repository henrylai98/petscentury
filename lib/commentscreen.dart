import 'package:flutter/material.dart';
import 'user.dart';
import 'post.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class CommentScreen extends StatefulWidget {
  final User user;
  final Post post;

  const CommentScreen({Key key, this.user, this.post}) : super(key: key);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  double screenHeight, screenWidth;
  List postList;
  String titlecenter = "Loading comments...";
  TextEditingController _commentcontroller = TextEditingController();
  String _comment="";

  @override
  void initState() {
    super.initState();
    _loadcomments();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      postList == null
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
                    _loadcomments();
                  },
                  child: ListView(
                      children: List.generate(postList.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                          child: Card(
                        child: Column(children: [
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).platform ==
                                                TargetPlatform.android
                                            ? Colors.white
                                            : Colors.white,
                                    backgroundImage: NetworkImage(
                                        "http://yhkywy.com/petscentury/images/profileimages/${widget.user.email}.jpg?"),
                                  )),
                              SizedBox(width: 10),
                              Text(postList[index]['postname'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ]),
                      )),
                    );
                  })))),
      
          TextField(
                  controller: _commentcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Comment...",
                      labelStyle: TextStyle(
                        color: Colors.brown,
                      ))),
          IconButton(
              iconSize: 25.0,
              icon: Icon(Icons.send, color: Colors.grey),
              onPressed: () => _addcomments()),
        
    
    ])));
  }

  void _addcomments() {
     _comment = _commentcontroller.text;
    print(widget.post.postimage);
    http.post("https://yhkywy.com/petscentury/php/addcomment.php", body: {
      "email": widget.user.email,
      "comment": _comment,
     "postimage":widget.post.postimage,
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

  Future<void> _loadcomments() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://yhkywy.com/petscentury/php/load_comment.php", body: {
      "postimage":widget.post.postimage,
      
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        postList = null;
        setState(() {
          titlecenter = "No Comment Found.";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          postList = jsondata["post"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }
}
