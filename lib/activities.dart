import 'package:flutter/material.dart';
import 'activity_tile.dart';

enum ActivityType {
  Running, Cycling, Walking,
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
        ),
        MyBottomSheet(),
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
                ActivityTile(type: ActivityType.Cycling,date: DateTime.now(), duration: Duration(minutes: 13), length: 3.5,),
                ActivityTile(type: ActivityType.Running,date: DateTime.now(), duration: Duration(minutes: 21), length: 1.3,),
                ActivityTile(type: ActivityType.Walking,date: DateTime.now(), duration: Duration(minutes: 42), length: 0.2,),
              ],
            ),
          );
        },
      ),
    );
  }
}


