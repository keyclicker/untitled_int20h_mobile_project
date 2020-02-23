import 'package:untitled_int20h_mobile_project/activities.dart';

import 'user.dart';
import 'package:flutter/material.dart';
import 'activities.dart';


class Hub{
  int id;
  String name;
  ActivityType type;
  List<User> participants;

  Hub(int id, String name, ActivityType type, List<User> participants){
    this.id = id;
    this.name = name;
    this.type = type;
    this.participants = participants;
  }
}


class HubWidget extends StatefulWidget {
  Hub hub;

  HubWidget(Hub hub){
    this.hub = hub;
  }

  @override
  _HubWidgetState createState() => _HubWidgetState(this.hub);
}

class _HubWidgetState extends State<HubWidget> {
  Hub hub;


  Color color;
  String title;
  IconData icon;
  ActivityType type;
  String subtitle;

  final contentColor = Colors.white;



  _HubWidgetState(Hub hub){
    this.hub = hub;
    if (hub.type == ActivityType.Running) {
      title = "Running ${this.hub.name}";
      icon = Icons.directions_run;
      color = Colors.teal[300];
    } else if (hub.type == ActivityType.Cycling) {
      title = "Cycling ${this.hub.name}";
      icon = Icons.directions_bike;
      color = Colors.blue[300];
    } else if (hub.type == ActivityType.Walking) {
      title = "Walking ${this.hub.name}";
      icon = Icons.directions_walk;
      color = Colors.redAccent[200];
    }
    subtitle = "${this.hub.participants.length} participants";
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


class HubListWidget extends StatefulWidget {
  List<Hub> hubs;

  HubListWidget(List<Hub> hubs){
    this.hubs = hubs;
  }

  @override
  _HubListWidgetState createState() => _HubListWidgetState(hubs);
}

class _HubListWidgetState extends State<HubListWidget> {
  List<Hub> hubs = [];

  _HubListWidgetState(List<Hub> hubs){
    this.hubs = hubs;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 25),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50,
                width: 200,
                padding: EdgeInsets.only(left: 30, right: 15),
                child: FlatButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                      "Create new hub",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                  ),),
                  onPressed: (){},
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                width: 200,
                padding: EdgeInsets.only(left: 15, right: 30),
                child: FlatButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                      "Join a hub",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                  ),),
                  onPressed: (){},
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 60, bottom: 20),
                child: Center(
                  child: Text(
                    "You are in ${hubs.length} hubs",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 150, bottom: 50),
            child: ListView.builder(
              itemCount: hubs.length,
              itemBuilder: (context, position) {
                return HubWidget(hubs[position]);
              },
            ),
          ),
        ],
      )
    );
  }
}
