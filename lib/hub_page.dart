import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson/miniUser.dart';
import 'activities.dart';
import 'hub.dart';
import 'user.dart';


class HubPage extends StatefulWidget {
  Hub hub;

  HubPage(Hub hub){
    this.hub = hub;
    this.hub.participants.sort((User left, User right){
      double leftScore = 0;
      double rightScore = 0;

      for (int i = 0; i < left.pastActivities.length; ++i){
        leftScore += left.pastActivities[i].distance;
      }

      for (int i = 0; i < right.pastActivities.length; ++i){
        rightScore += right.pastActivities[i].distance;
      }
      return rightScore.compareTo(leftScore);
    });
  }


  @override
  _HubPageState createState() => _HubPageState(hub);
}

class _HubPageState extends State<HubPage> {
  Hub hub;

  _HubPageState(Hub hub){
    this.hub = hub;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget> [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 5),
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    )
                  ]),
              child: Container(
                color: Colors.blue,
                height: 200,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 60,),
                        child: Icon(Icons.directions_run, size: 30, color: Colors.white,)
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("${hub.name}",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                initialChildSize: 0.67,
                maxChildSize: 0.67,
                minChildSize: 0.67,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView(
                        controller: scrollController,
                        children: hub.participants.map(
                            (participant){ return MiniUserWidget(participant); }
                        ).toList(),
                    ),
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}


class ActivityRecord extends StatelessWidget {
  ActivityType type;
  DateTime date;
  Duration duration;

  var title, subtitle, icon, length;
  Color color;

  final contentColor = Colors.white;

  String stringDate() {
    return "${date.hour < 10 ? 0 : ''}${date.hour}:${date.minute < 10 ? 0 : ''}${date.minute}"
        " ${months[date.month - 1]} ${date.day}";
  }

  ActivityRecord({this.type, this.date, this.duration, this.length}) {
    subtitle = stringDate();
    if (type == ActivityType.Running) {
      title = "Running";
      icon = Icons.directions_run;
      color = Colors.teal[300];
    } else if (type == ActivityType.Cycling) {
      title = "Cycling";
      icon = Icons.directions_bike;
      color = Colors.blue[300];
    } else if (type == ActivityType.Walking) {
      title = "Walking";
      icon = Icons.directions_walk;
      color = Colors.redAccent[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(5, 5),
            )
          ]),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Center(
        child: ListTile(
          title: Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: contentColor)),
          subtitle: Text(subtitle,
              style: TextStyle(fontSize: 12, color: contentColor)),
          leading: Icon(icon, size: 40, color: contentColor),
        ),
      ),
    );
  }
}

var months = <String>[
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "Octovber",
  "November",
  "December"
];