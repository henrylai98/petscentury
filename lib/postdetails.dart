import 'package:flutter/material.dart';
import 'post.dart';
import 'user.dart';
 

 
class PostDetails extends StatefulWidget {
    final Post post;
  final User user;

  const PostDetails({Key key, this.post, this.user}) : super(key: key);
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}