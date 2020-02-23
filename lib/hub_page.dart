import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'activities.dart';
class HubPage extends StatefulWidget {
  @override
  _HubPageState createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("lom"),
          Container(
            color: Colors.red,
            height: 200,
            child: Row(
              children: <Widget>[
                Icon(Icons.directions_bike, size: 20,),

              ],
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
