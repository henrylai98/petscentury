import 'package:flutter/material.dart';
import 'package:petscentury/newpostscreen.dart';
import 'user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'commentscreen.dart';


class PostScreen extends StatefulWidget {
  final User user;
  

  const PostScreen({Key key, this.user, }) : super(key: key);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with TickerProviderStateMixin {
  List postList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Post...";
  GlobalKey<RefreshIndicatorState> refreshKey;
  int durationAnimationBox = 500;
  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 1000;
  AnimationController animControlBtnLongPress, animControlBox;
  Animation zoomIconLikeInBtn, tiltIconLikeInBtn, zoomTextLikeInBtn;
  Animation fadeInBox;
  Animation moveRightGroupIcon;
  Animation pushIconLikeUp,
      pushIconLoveUp,
      pushIconHahaUp,
      pushIconWowUp,
      pushIconSadUp,
      pushIconAngryUp;
  Animation zoomIconLike,
      zoomIconLove,
      zoomIconHaha,
      zoomIconWow,
      zoomIconSad,
      zoomIconAngry;
  AnimationController animControlBtnShortPress;
  Animation zoomIconLikeInBtn2, tiltIconLikeInBtn2;
  AnimationController animControlIconWhenDrag;
  AnimationController animControlIconWhenDragInside;
  AnimationController animControlIconWhenDragOutside;
  AnimationController animControlBoxWhenDragOutside;
  Animation zoomIconChosen, zoomIconNotChosen;
  Animation zoomIconWhenDragOutside;
  Animation zoomIconWhenDragInside;
  Animation zoomBoxWhenDragOutside;
  Animation zoomBoxIcon;
  AnimationController animControlIconWhenRelease;
  Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  Animation moveLeftIconLikeWhenRelease,
      moveLeftIconLoveWhenRelease,
      moveLeftIconHahaWhenRelease,
      moveLeftIconWowWhenRelease,
      moveLeftIconSadWhenRelease,
      moveLeftIconAngryWhenRelease;

  Duration durationLongPress = Duration(milliseconds: 250);
  Timer holdTimer;
  bool isLongPress = false;
  bool isLiked = false;
  int whichIconUserChoose = 0;
  int currentIconFocus = 0;
  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  @override
  void initState() {
    super.initState();

    _loadposts();
    initAnimationBtnLike();
    initAnimationBoxAndIcons();
    initAnimationIconWhenDrag();
    initAnimationIconWhenDragOutside();
    initAnimationBoxWhenDragOutside();
    initAnimationIconWhenDragInside();
    initAnimationIconWhenRelease();
  }

  initAnimationBtnLike() {
    animControlBtnLongPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnLongPress));
    zoomIconLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);
    tiltIconLikeInBtn =
        Tween(begin: 0.0, end: 0.2).animate(animControlBtnLongPress);
    zoomTextLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);

    zoomIconLikeInBtn.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn.addListener(() {
      setState(() {});
    });
    zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    // short press
    animControlBtnShortPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconLikeInBtn2 =
        Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconLikeInBtn2 =
        Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);

    zoomIconLikeInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn2.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxAndIcons() {
    animControlBox = AnimationController(
        vsync: this, duration: Duration(milliseconds: durationAnimationBox));

    moveRightGroupIcon = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.7, 1.0)),
    );
    fadeInBox.addListener(() {
      setState(() {});
    });

    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );

    pushIconLikeUp.addListener(() {
      setState(() {});
    });
    zoomIconLike.addListener(() {
      setState(() {});
    });
    pushIconLoveUp.addListener(() {
      setState(() {});
    });
    zoomIconLove.addListener(() {
      setState(() {});
    });
    pushIconHahaUp.addListener(() {
      setState(() {});
    });
    zoomIconHaha.addListener(() {
      setState(() {});
    });
    pushIconWowUp.addListener(() {
      setState(() {});
    });
    zoomIconWow.addListener(() {
      setState(() {});
    });
    pushIconSadUp.addListener(() {
      setState(() {});
    });
    zoomIconSad.addListener(() {
      setState(() {});
    });
    pushIconAngryUp.addListener(() {
      setState(() {});
    });
    zoomIconAngry.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDrag() {
    animControlIconWhenDrag = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));

    zoomIconChosen =
        Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
    zoomIconNotChosen =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon =
        Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragOutside =
        Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomBoxWhenDragOutside =
        Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragInside =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  initAnimationIconWhenRelease() {
    animControlIconWhenRelease = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenRelease));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0).animate(CurvedAnimation(
        parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveLeftIconLikeWhenRelease = Tween(begin: 20.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconLoveWhenRelease = Tween(begin: 68.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconHahaWhenRelease = Tween(begin: 116.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconWowWhenRelease = Tween(begin: 164.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconSadWhenRelease = Tween(begin: 212.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconAngryWhenRelease = Tween(begin: 260.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });

    moveLeftIconLikeWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconLoveWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconHahaWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconWowWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconSadWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconAngryWhenRelease.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            body: Container(
                color: Color(0xFFFFF3E0),
                child: Column(
                  children: [
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
                                  _loadposts();
                                },
                                child: GridView.count(
                                  crossAxisCount: 1,
                                  childAspectRatio:
                                      (screenWidth / screenHeight) / 0.65,
                                  children:
                                      List.generate(postList.length, (index) {
                                    return Padding(
                                        padding: EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                          child: Card(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: CircleAvatar(
                                                          backgroundColor: Theme.of(
                                                                          context)
                                                                      .platform ==
                                                                  TargetPlatform
                                                                      .android
                                                              ? Colors.white
                                                              : Colors.white,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  "http://yhkywy.com/petscentury/images/profileimages/${widget.user.email}.jpg?"),
                                                        )),
                                                    SizedBox(width: 10),
                                                    Text(
                                                        postList[index]
                                                            ['postname'],
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(width: 50),
                                                    Text(
                                                        postList[index]
                                                            ['postdate'],
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                          postList[index]
                                                              ['poststory'],
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          )),
                                                    ),
                                                    Stack(children: [
                                                      Container(
                                                          height: screenHeight /
                                                              2.5,
                                                          width:
                                                              screenWidth / 1,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                "http://yhkywy.com/petscentury/images/postimages/${postList[index]['postimage']}.jpg",
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    url) =>
                                                                new CircularProgressIndicator(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    new Icon(
                                                              Icons
                                                                  .broken_image,
                                                              size:
                                                                  screenWidth /
                                                                      1.5,
                                                            ),
                                                          )),
                                                      GestureDetector(
                                                        child: Container(
                                                          child: Column(
                                                              children: [
                                                                Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        // Box
                                                                        renderBox(),

                                                                        // Icons
                                                                        renderIcons(),
                                                                      ],
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                    ),

                                                                    // Button like
                                                                    renderBtnLike(),
                                                                    // Icons when jump
                                                                    // Icon like
                                                                    whichIconUserChoose ==
                                                                                1 &&
                                                                            !isDragging
                                                                        ? Container(
                                                                            child:
                                                                                Transform.scale(
                                                                              child: Image.asset(
                                                                                'assets/images/like.gif',
                                                                                width: 40.0,
                                                                                height: 40.0,
                                                                              ),
                                                                              scale: this.zoomIconWhenRelease.value,
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(
                                                                              top: processTopPosition(this.moveUpIconWhenRelease.value),
                                                                              left: this.moveLeftIconLikeWhenRelease.value,
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    // Icon love
                                                                    whichIconUserChoose ==
                                                                                2 &&
                                                                            !isDragging
                                                                        ? Container(
                                                                            child:
                                                                                Transform.scale(
                                                                              child: Image.asset(
                                                                                'assets/images/love.gif',
                                                                                width: 40.0,
                                                                                height: 40.0,
                                                                              ),
                                                                              scale: this.zoomIconWhenRelease.value,
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(
                                                                              top: processTopPosition(this.moveUpIconWhenRelease.value),
                                                                              left: this.moveLeftIconLoveWhenRelease.value,
                                                                            ),
                                                                          )
                                                                        : Container(),

                                                                    // Icon haha
                                                                    whichIconUserChoose ==
                                                                                3 &&
                                                                            !isDragging
                                                                        ? Container(
                                                                            child:
                                                                                Transform.scale(
                                                                              child: Image.asset(
                                                                                'assets/images/haha.gif',
                                                                                width: 40.0,
                                                                                height: 40.0,
                                                                              ),
                                                                              scale: this.zoomIconWhenRelease.value,
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(
                                                                              top: processTopPosition(this.moveUpIconWhenRelease.value),
                                                                              left: this.moveLeftIconHahaWhenRelease.value,
                                                                            ),
                                                                          )
                                                                        : Container(),

                                                                    // Icon Wow
                                                                    whichIconUserChoose ==
                                                                                4 &&
                                                                            !isDragging
                                                                        ? Container(
                                                                            child:
                                                                                Transform.scale(
                                                                              child: Image.asset(
                                                                                'assets/images/wow.gif',
                                                                                width: 40.0,
                                                                                height: 40.0,
                                                                              ),
                                                                              scale: this.zoomIconWhenRelease.value,
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(
                                                                              top: processTopPosition(this.moveUpIconWhenRelease.value),
                                                                              left: this.moveLeftIconWowWhenRelease.value,
                                                                            ),
                                                                          )
                                                                        : Container(),

                                                                    // Icon sad
                                                                    whichIconUserChoose ==
                                                                                5 &&
                                                                            !isDragging
                                                                        ? Container(
                                                                            child:
                                                                                Transform.scale(
                                                                              child: Image.asset(
                                                                                'assets/images/sad.gif',
                                                                                width: 40.0,
                                                                                height: 40.0,
                                                                              ),
                                                                              scale: this.zoomIconWhenRelease.value,
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(
                                                                              top: processTopPosition(this.moveUpIconWhenRelease.value),
                                                                              left: this.moveLeftIconSadWhenRelease.value,
                                                                            ),
                                                                          )
                                                                        : Container(),

                                                                    // Icon angry
                                                                    whichIconUserChoose ==
                                                                                6 &&
                                                                            !isDragging
                                                                        ? Container(
                                                                            child:
                                                                                Transform.scale(
                                                                              child: Image.asset(
                                                                                'assets/images/angry.gif',
                                                                                width: 40.0,
                                                                                height: 40.0,
                                                                              ),
                                                                              scale: this.zoomIconWhenRelease.value,
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(
                                                                              top: processTopPosition(this.moveUpIconWhenRelease.value),
                                                                              left: this.moveLeftIconAngryWhenRelease.value,
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    color: Colors
                                                                        .white,
                                                                    height: 40,
                                                                    width: 130,
                                                                    child: Row(
                                                                      children: [
                                                                        IconButton(
                                                                            iconSize:
                                                                                25.0,
                                                                            icon:
                                                                                Icon(Icons.chat_bubble_outline, color: Colors.grey),
                                                                            onPressed: () => _loadPostDetails(index)),
                                                                        Text(
                                                                            "Comment",
                                                                            style:
                                                                                TextStyle(fontSize: 15, color: Colors.grey))
                                                                      ],
                                                                    )),
                                                              ]),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20.0,
                                                                  right: 20.0),
                                                          // Area of the content can drag
                                                          // decoration:  BoxDecoration(border: Border.all(color: Colors.grey)),
                                                          width:
                                                              double.infinity,
                                                          height: 350.0,
                                                        ),
                                                        onHorizontalDragEnd:
                                                            onHorizontalDragEndBoxIcon,
                                                        onHorizontalDragUpdate:
                                                            onHorizontalDragUpdateBoxIcon,
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  }),
                                ))),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    NewPostScreen(user: widget.user)));
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.brown,
                    ),
                  ],
                ))));
  }

  Widget renderIcons() {
    return Container(
      child: Row(
        children: <Widget>[
          // icon like
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 1
                      ? Container(
                          child: Text(
                            'Like',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/like.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconLikeUp.value),
              width: 40.0,
              height: currentIconFocus == 1 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 1
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 1
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconLike.value,
          ),

          // icon love
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 2
                      ? Container(
                          child: Text(
                            'Love',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/love.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconLoveUp.value),
              width: 40.0,
              height: currentIconFocus == 2 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 2
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 2
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconLove.value,
          ),

          // icon haha
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 3
                      ? Container(
                          child: Text(
                            'Haha',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/haha.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconHahaUp.value),
              width: 40.0,
              height: currentIconFocus == 3 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 3
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 3
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconHaha.value,
          ),

          // icon wow
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 4
                      ? Container(
                          child: Text(
                            'Wow',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/wow.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconWowUp.value),
              width: 40.0,
              height: currentIconFocus == 4 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 4
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 4
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconWow.value,
          ),

          // icon sad
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 5
                      ? Container(
                          child: Text(
                            'Sad',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/sad.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconSadUp.value),
              width: 40.0,
              height: currentIconFocus == 5 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 5
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 5
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconSad.value,
          ),

          // icon angry
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 6
                      ? Container(
                          child: Text(
                            'Angry',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/angry.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconAngryUp.value),
              width: 40.0,
              height: currentIconFocus == 6 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 6
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 6
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconAngry.value,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      width: 300.0,
      height: 250.0,
      margin: EdgeInsets.only(left: this.moveRightGroupIcon.value, top: 50.0),
      // uncomment here to see area of draggable
      // color: Colors.amber.withOpacity(0.5),
    );
  }

  Widget renderBtnLike() {
    return Container(
      child: GestureDetector(
        onTapDown: onTapDownBtn,
        onTapUp: onTapUpBtn,
        onTap: onTapBtn,
        child: Container(
          child: Row(
            children: <Widget>[
              // Icon like
              Transform.scale(
                child: Transform.rotate(
                  child: Image.asset(
                    getImageIconBtn(),
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.contain,
                    color: getTintColorIconBtn(),
                  ),
                  angle: !isLongPress
                      ? handleOutputRangeTiltIconLike(tiltIconLikeInBtn2.value)
                      : tiltIconLikeInBtn.value,
                ),
                scale: !isLongPress
                    ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value)
                    : zoomIconLikeInBtn.value,
              ),

              // Text like
              Transform.scale(
                child: Text(
                  getTextBtn(),
                  style: TextStyle(
                    color: getColorTextBtn(),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                scale: !isLongPress
                    ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value)
                    : zoomTextLikeInBtn.value,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          padding: EdgeInsets.all(10.0),
          color: Colors.transparent,
        ),
      ),
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
        border: Border.all(color: getColorBorderBtn()),
      ),
      margin: EdgeInsets.only(top: 190.0),
    );
  }

  Widget renderBox() {
    return Opacity(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey[300], width: 0.3),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                // LTRB
                offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)),
          ],
        ),
        width: 300.0,
        height: isDragging
            ? (previousIconFocus == 0 ? this.zoomBoxIcon.value : 40.0)
            : isDraggingOutside
                ? this.zoomBoxWhenDragOutside.value
                : 50.0,
        margin: EdgeInsets.only(bottom: 130.0, left: 10.0),
      ),
      opacity: this.fadeInBox.value,
    );
  }

  void onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = new Timer(durationLongPress, showBox);
  }

  void onTapUpBtn(TapUpDetails tapUpDetail) {
    new Timer(new Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });

    holdTimer.cancel();

    animControlBtnLongPress.reverse();
    setReverseValue();

    animControlBox.reverse();

    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  // when user short press the button
  void onTapBtn() {
    if (!isLongPress) {
      if (whichIconUserChoose == 0) {
        isLiked = !isLiked;
      } else {
        whichIconUserChoose = 0;
      }
      if (isLiked) {
        animControlBtnShortPress.forward();
      } else {
        animControlBtnShortPress.reverse();
      }
    }
  }

  double handleOutputRangeZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  double handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  String getTextBtn() {
    if (isDragging) {
      return 'Like';
    }
    switch (whichIconUserChoose) {
      case 1:
        return 'Like';
      case 2:
        return 'Love';
      case 3:
        return 'Haha';
      case 4:
        return 'Wow';
      case 5:
        return 'Sad';
      case 6:
        return 'Angry';
      default:
        return 'Like';
    }
  }

  Color getColorTextBtn() {
    if ((!isLongPress && isLiked)) {
      return Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xff3b5998);
        case 2:
          return Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return Color(0xffFFD96A);
        case 6:
          return Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }

  String getImageIconBtn() {
    if (!isLongPress && isLiked) {
      return 'assets/images/ic_like_fill.png';
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return 'assets/images/ic_like_fill.png';
        case 2:
          return 'assets/images/love2.png';
        case 3:
          return 'assets/images/haha2.png';
        case 4:
          return 'assets/images/wow2.png';
        case 5:
          return 'assets/images/sad2.png';
        case 6:
          return 'assets/images/angry2.png';
        default:
          return 'assets/images/ic_like.png';
      }
    } else {
      return 'assets/images/ic_like.png';
    }
  }

  void setReverseValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
  }

  // When set the reverse value, we need set value to normal for the forward
  void setForwardValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
  }

  Color getTintColorIconBtn() {
    if (!isLongPress && isLiked) {
      return Color(0xff3b5998);
    } else if (!isDragging && whichIconUserChoose != 0) {
      return null;
    } else {
      return Colors.grey;
    }
  }

  double processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
  }

  Color getColorBorderBtn() {
    if ((!isLongPress && isLiked)) {
      return Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xff3b5998);
        case 2:
          return Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return Color(0xffFFD96A);
        case 6:
          return Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey[400];
    }
  }

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    onTapUpBtn(null);
  }

  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    // return if the drag is drag without press button
    if (!isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (dragUpdateDetail.globalPosition.dy >= 200 &&
        dragUpdateDetail.globalPosition.dy <= 500) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (dragUpdateDetail.globalPosition.dx >= 20 &&
          dragUpdateDetail.globalPosition.dx < 83) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 83 &&
          dragUpdateDetail.globalPosition.dx < 126) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 126 &&
          dragUpdateDetail.globalPosition.dx < 180) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 180 &&
          dragUpdateDetail.globalPosition.dx < 233) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 233 &&
          dragUpdateDetail.globalPosition.dx < 286) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 286 &&
          dragUpdateDetail.globalPosition.dx < 340) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      }
    } else {
      whichIconUserChoose = 0;
      previousIconFocus = 0;
      currentIconFocus = 0;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void handleWhenDragBetweenIcon(int currentIcon) {
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  void showBox() {
    isLongPress = true;

    animControlBtnLongPress.forward();
    setForwardValue();

    animControlBox.forward();
  }

  // We need to set the value for reverse because if not
  // the angry-icon will be pulled down first, not the like-icon

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  Future<void> _loadposts() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://yhkywy.com/petscentury/php/load_post.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        postList = null;
        setState(() {
          titlecenter = "No Post Available";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          postList = jsondata["posts"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

   _loadPostDetails(int index) {
    Post post = new Post(
        postemail: postList[index]['email'],
        postimage: postList[index]['postimage'],
        datetime:postList[index]['datetime']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>CommentScreen(
                  post: post,
                  user: widget.user,
    )));
                _loadposts();
  }
}



