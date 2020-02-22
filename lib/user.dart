import 'package:flutter/material.dart';
import 'package:untitled_int20h_mobile_project/activity_tile.dart';
import 'activities.dart';
import 'hub.dart';


class User{
  String nickname;
  int age;
  String imageUrl;
  List<Activity> pastActivities;
  List<User> followers;
  List<User> following;
  List<Hub> myHubs;


  User(String nick, int age){
    this.nickname = nick;
    this.age = age;
    this.imageUrl = "https://u.o0bc.com/avatars/stock/_no-user-image.gif";
    this.following = [];
    this.followers = [];
    this.pastActivities = [
      Activity(ActivityType.Cycling, DateTime.now(), Duration(minutes: 10, hours: 5), 10),
      Activity(ActivityType.Running, DateTime.now(), Duration(minutes: 50, hours: 2), 12),
      Activity(ActivityType.Walking, DateTime.now(), Duration(minutes: 15, hours: 8), 13)
    ];
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
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
            ),
          child: Container(
            child: Text(
              "Follow",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
            ),
          ),
        ) : FlatButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.blue)
            ),
            onPressed: (){},
            child: Container(
              child: Text(
                  "Followed",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue
                ),
              ),
            ),
          ),
          Container(
            child: Text(
                "Recent activities",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Column(
            children: me.pastActivities.map((activity){
              return ActivityTile(
                type: activity.type,
                duration: activity.actionDuration,
                date: activity.actionDate,
                length: activity.distance,
              );
            }).toList(),
          )
      ],
      ),
    );
  }
}
