import 'package:flutter/material.dart';
import 'activity_tile.dart';
import 'dart:async';
import 'dart:math';

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
          child: Timer(),
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

class _MyBottomSheetState extends State<MyBottomSheet>{
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: 0.075,
        maxChildSize: 0.55,
        minChildSize: 0.075,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child:
                ListView(
                  padding: EdgeInsets.only(top: 8),
                  controller: scrollController,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 5,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[200],
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 22 , top: 10, bottom: 8),
                      child: Text("Last activities",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ),
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

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer>{
  var stopwatch = new Stopwatch();

  String timeToString(int time) {
    return "${time < 10 ? '0' : ''}$time";
  }

  @override
  void initState() {
    super.initState();
//    Timer.periodic(Duration(seconds: 1), (Timer t) {
//      setState(() {
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(height: 80),
            Text(
            "${timeToString(stopwatch.elapsed.inMinutes)}:"
                "${timeToString(stopwatch.elapsed.inSeconds-stopwatch.elapsed.inMinutes*60)}",
                style: TextStyle(
                fontSize: 100,
                color: Colors.white,
                fontWeight: FontWeight.w400
              )
            ),
            Container(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(3, 5),
                )],
                color: Colors.blueAccent
              ),
              height: 60,
              width: 60,
              child: FlatButton(
                child: Icon(stopwatch.isRunning ? Icons.stop : Icons.play_arrow,
                color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (stopwatch.isRunning)
                      stopwatch.stop();
                    else
                      stopwatch.start();
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}



