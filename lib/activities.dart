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
          child: PageView(
            children: <Widget>[
              TimerWidget(type: ActivityType.Running),
              TimerWidget(type: ActivityType.Walking),
              TimerWidget(type: ActivityType.Cycling),
            ],
          )
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
        maxChildSize: 0.545,
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
                    ActivityTile(type: ActivityType.Cycling,
                      date: DateTime.now(),
                      duration: Duration(minutes: 13),
                      length: 3.5,),
                  ],
                ),
          );
        },
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  ActivityType type;
  TimerWidget({this.type});

  @override
  _TimerWidgetState createState() => _TimerWidgetState(type: type);
}

class _TimerWidgetState extends State<TimerWidget>{
  var stopwatch = new Stopwatch();

  ActivityType type;
  _TimerWidgetState({this.type});

  String timeToString(int time) {
    return "${time < 10 ? '0' : ''}$time";
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (){
        if(type == ActivityType.Running) return Colors.blue[450];
        if(type == ActivityType.Walking) return Colors.teal;
        if(type == ActivityType.Cycling) return Colors.redAccent;
      }(),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(height: 50),
            Text((){
              if(type == ActivityType.Running) return "Running";
              if(type == ActivityType.Walking) return "Walking";
              if(type == ActivityType.Cycling) return "Cycling";
            }(),
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                )),
            Container(height: 8),
            Text(
            "${timeToString(stopwatch.elapsed.inMinutes)}:"
                "${timeToString(stopwatch.elapsed.inSeconds-stopwatch.elapsed.inMinutes*60)}",
                style: TextStyle(
                fontSize: 100,
                color: Colors.white,
                fontWeight: FontWeight.w400
              )
            ),
            Container(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(3, 5),
                )],
                color: (){
                  if(type == ActivityType.Running) return Colors.deepOrangeAccent;
                  if(type == ActivityType.Walking) return Colors.orange[500];
                  if(type == ActivityType.Cycling) return Colors.green[400];
                }(),
              ),
              height: 60,
              width: 180,
              child: FlatButton(
                child: Text(stopwatch.isRunning ? "Stop" : "Start",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    )
                ),
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
