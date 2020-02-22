import 'dart:html';

import 'package:flutter/material.dart';
import 'activity.dart';
import 'hub.dart';


class User{
  int id;
  String nickname;
  int age;
  String imageUrl;
  List<Activity> pastActivities;
  List<User> followers;
  List<User> following;
  List<Hub> myHubs;


  User(int id, String nick, int age){
    this.id = id;
    this.nickname = nick;
    this.age = age;
    this.imageUrl = "https://u.o0bc.com/avatars/stock/_no-user-image.gif";
    this.following = [];
    this.followers = [];
  }

  void addActivity(Activity activity){
    this.pastActivities.add(activity);
  }

  void addFollower(User follower){
    this.followers.add(follower);
  }

  void addFollowing(User following){
    this.following.add(following);
  }

  bool iFollow(User other){
    return this.following.contains(other);
  }
}


class UserWidget extends StatefulWidget {
  User user;
  User me;

  UserWidget(User user, User me){
    this.user = user;
    this.me = me;
  }

  @override
  _UserState createState() => _UserState(this.user, this.me);
}


class _UserState extends State<UserWidget> {
  User user;
  User me;

  _UserState(User user, User me){
    this.user = user;
    this.me = me;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(width: 30, height: 30,),
          Row(
            children: <Widget>[
              SizedBox(width: 30, height: 30),
              ClipRRect(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image(
                    image: NetworkImage(user.imageUrl),
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      "${user.nickname}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "${user.age} years old",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                      children: <Widget> [
                        Container(
                          child: Align(
                            child: FlatButton(
                              onPressed: (){},
                              child: Text(
                                "${user.followers.length} followers",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Container(
                          child: Align(
                            child: FlatButton(
                              onPressed: (){},
                              child: Text(
                                "${user.following.length} following",
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ]
                  )
                ],
              )
            ],
          ),
          user == me ? SizedBox(width: 0, height: 0,) : !me.iFollow(user) ? FlatButton(
                    onPressed: () {
                      setState ( () {
                        me.addFollowing(user);
                        user.addFollower(me);
                      });

                    },
          child: Container(
            child: Text(
              "Follow",
                style: TextStyle(
                  fontSize: 18,
                ),
            ),
          ),
        ) : FlatButton(
            onPressed: (){},
            child: Container(
              child: Text(
                  "Follow",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          )

      ],
      ),
    );
  }
}
