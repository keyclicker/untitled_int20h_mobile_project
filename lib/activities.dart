import 'package:flutter/material.dart';
import 'activity_tile.dart';

enum ActivityType {
  Running,
  Cycling,
  Walking,
}

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.blue,
          child: _drawInfo(),
        ),
        MyBottomSheet(),
      ],
    );
  }

  Widget _drawValue(double value, String sub) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Column(
        children: <Widget>[
          Text("${value}",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
              )),
          Text(sub,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
              ))
        ],
      ),
    );
  }


  Widget _drawInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _drawValue(1.4, "km"),
            _drawValue(21, "min"),
            _drawValue(40, "km/h"),
          ],
        ),

        Container(height: 20),

        Text("Best resault for this track",
            style: TextStyle(fontSize: 25, color: Colors.white)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _drawValue(21, "min"),
            _drawValue(40, "km/h"),
          ],
        ),


      ],
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: scrollController,
              children: <Widget>[
                ActivityTile(type: ActivityType.Cycling,
                  date: DateTime.now(),
                  duration: Duration(minutes: 13),
                  length: 3.5,),
                ActivityTile(
                  type: ActivityType.Running,
                  date: DateTime.now(),
                  duration: Duration(minutes: 21),
                  length: 1.3,),
                ActivityTile(
                  type: ActivityType.Walking,
                  date: DateTime.now(),
                  duration: Duration(minutes: 42),
                  length: 0.2,),
              ],
            ),
          );
        },
      ),
    );
  }
}


class Activity{
  ActivityType type;
  DateTime actionDate;
  Duration actionDuration;
  double distance;

  Activity(ActivityType type, DateTime actionDate, Duration actionDuration, double distance){
    this.type = type;
    this.actionDate = actionDate;
    this.actionDuration = actionDuration;
    this.distance = distance;
  }
}
