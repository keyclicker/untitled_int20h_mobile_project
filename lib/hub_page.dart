import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'activities.dart';
import 'dart:math';
import 'hub.dart';

class HubPage extends StatefulWidget {
  Hub hub;

  HubPage(Hub hub){
    this.hub = hub;
  }

  @override
  _HubPageState createState() => _HubPageState(hub);
}

class _HubPageState extends State<HubPage> {
  var rand = Random();

  Hub hub;
  String type;

  _HubPageState(Hub hub){
    this.hub = hub;

    if (hub.type == ActivityType.Cycling){
      type = "Cycling";
    } else if (hub.type == ActivityType.Running){
      type = "Running";
    } else {
      type = "Walking";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  )]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(width: 10),
                  Icon(Icons.directions_bike,size: 150, color: Colors.black.withOpacity(0.8),),
                  Column(
                    children: <Widget>[
                      Container(height: 20),
                      Text("${hub.name}",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600
                          )),
                      Container(height: 7),
                      Row(
                        children: <Widget>[
                          Text("40",
                              style: TextStyle(
                                  fontSize:20,
                                  fontWeight: FontWeight.w600
                              )),
                          Text(" participants",
                              style: TextStyle(
                                  fontSize:20,
                                  fontWeight: FontWeight.w400
                              )),
                        ],
                      ),
                      Container(height: 12),
                      SizedBox(
                        width: 175,
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          child: Text("Subscribe",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () {

                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index){
                return ActivityRecord(
                  type: ActivityType.Cycling,
                  length: 10,
                  date: DateTime.now(),
                  duration: Duration(minutes: 24),);
              })
        ],
      ),
    );;
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
          trailing: _buildInfo(),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text("${duration.inMinutes}",
                style: TextStyle(fontSize: 35, color: contentColor)),
            Text("min", style: TextStyle(fontSize: 12, color: contentColor))
          ],
        ),
        Container(
          width: 20,
        ),
        Column(
          children: <Widget>[
            Text("${length}",
                style: TextStyle(fontSize: 35, color: contentColor)),
            Text("km", style: TextStyle(fontSize: 12, color: contentColor))
          ],
        )
      ],
    );
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
}
