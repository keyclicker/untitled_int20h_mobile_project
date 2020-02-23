import 'package:flutter/material.dart';
import 'activity_tile.dart';
import 'activities.dart';
import 'hub.dart';
import 'server/client.dart';


var ActivityTypesDict = {
  "running": ActivityType.Running,
  "cycling": ActivityType.Cycling,
  "walking": ActivityType.Walking
};


class User{
  String nickname;
  int age;
  String imageUrl;
  List<Activity> pastActivities = [];
  List<User> followers = [];
  List<User> following = [];
  List<Hub> myHubs = [];


  User({String nick, int age = 0, weak = true}){
    this.nickname = nick;
    this.age = age;
    this.pastActivities = [
      Activity(
        ActivityType.Running,
        DateTime.now(),
        Duration(minutes: 14, seconds: 55),
        3.2
      ),
      Activity(
        ActivityType.Cycling,
        DateTime.utc(2020, 02, 12, 13, 0, 0),
        Duration(minutes: 55, seconds: 30),
        25
      )
    ];
    this.myHubs = [
      Hub(name: "Evo sport club", type: ActivityType.Running, participants: [this]),
      Hub(name: "BetterME", type: ActivityType.Cycling, participants: [this]),
    ];
    this.followers = [];
    this.following = [];
    this.imageUrl = "https://u.o0bc.com/avatars/stock/_no-user-image.gif";
    if (!weak){
      setHubs();
      setActivities();
    }
  }

  void setHubs() async {
    List<String> hubs = await getUserHubs(this.nickname);

    for (int i = 0; i < hubs.length; ++i){
      HubResponse response = await getHub(hubs[i]);
      Hub hub = Hub(name: response.title);
      if (response.category == "running"){
        hub.type = ActivityType.Running;
      } else if (response.category == "walking"){
        hub.type = ActivityType.Walking;
      } else {
        hub.type = ActivityType.Cycling;
      }
      var members = response.members;
      for (int j = 0; j < members.length; ++j){
        hub.participants.add(User(nick: members[j]));
      }
      print("Hub " + hub.name + " " + hub.participants.length.toString());
      addHub(hub);
    }
  }


  void setActivities() async {
    List<ActivityResponse> activities = await getActivities(this.nickname);


    for (var activity in activities){
      List<String> durationParts = activity.time.split(":");
      Activity act = Activity(
        ActivityTypesDict[activity.category],
        DateTime.parse(activity.date),
      Duration(minutes: int.parse(durationParts[0]), seconds: int.parse(durationParts[1])),
      double.parse(activity.distanceValue));

      pastActivities.add(act);
    }
  }

  void addHub(Hub hub){
    this.myHubs.add(hub);
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
                                            builder: (context){
                                              print(this.user.myHubs[0].participants.length);
                                              return HubListWidget(this.user.myHubs);
                                            }
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
