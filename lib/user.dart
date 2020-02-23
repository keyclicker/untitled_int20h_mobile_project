import 'package:flutter/material.dart';
import 'package:untitled_int20h_mobile_project/activity_tile.dart';
import 'activities.dart';
import 'hub.dart';
import 'package:untitled_int20h_mobile_project/server/client.dart';


class User{
  String nickname;
  int age;
  String imageUrl;
  List<Activity> pastActivities;
  List<User> followers;
  List<User> following;
  List<Hub> myHubs;


  User({String nick, int age = 0}){
    this.nickname = nick;
    this.age = age;
    this.imageUrl = "https://u.o0bc.com/avatars/stock/_no-user-image.gif";
    this.following = [];
    this.followers = [];
    this.pastActivities = [];
    this.myHubs = [];
    setHubs();
  }

  void setHubs() async {
    print(this.nickname);
    List<String> hubs = await getUserHubs(this.nickname);
    for (int i = 0; i < hubs.length; ++i){
      HubResponce response = await getHub(hubs[i]);
      Hub hub = Hub(name: response.title);
      if (response.category == "Running"){
        hub.type = ActivityType.Running;
      } else if (response.category == "Walking"){
        hub.type = ActivityType.Walking;
      } else {
        hub.type = ActivityType.Cycling;
      }
      var members = response.members;
      for (int j = 0; j < members.length; ++j){
        hub.participants.add(User(nick: members[j]));
      }
      this.myHubs.add(hub);
    }
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
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  )],
                ),
                child: Row(
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
                          padding: EdgeInsets.only(left: 25, bottom: 10),
                          child: Text(
                            "${user.nickname}",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, bottom: 15),
                          child: Text(
                            "${user.age} years old",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                            children: <Widget> [
                              Container(
                                child: FlatButton(
                                  onPressed: (){},
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "${user.followers.length}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text("followers",
                                        style: TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: FlatButton(
                                  onPressed: (){},
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "${user.following.length}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "following",
                                        style: TextStyle(
                                            fontSize: 14
                                        ),)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: FlatButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context){ return HubListWidget(this.user.myHubs);}
                                        )
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "${user.myHubs.length}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text("hubs",
                                        style: TextStyle(
                                            fontSize: 14
                                        ),)
                                    ],
                                  ),
                                ),
                              )
                            ]
                        )
                      ],
                    )
                  ],
                ),
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
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "Recent activities",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(

            initialChildSize: 0.7,
            maxChildSize: 0.7,
            minChildSize: 0.7,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                    controller: scrollController,
                    children: me.pastActivities.map((activity){
                      return ActivityTile(
                        type: activity.type,
                        duration: activity.actionDuration,
                        date: activity.actionDate,
                        length: activity.distance,
                      );
                    }).toList()
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
