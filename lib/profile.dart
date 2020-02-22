import 'package:flutter/material.dart';
import 'user.dart';
import 'activity.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = User(1, "oleksii", 19);
  User me = User(2, "sasha", 20);

  @override
  Widget build(BuildContext context) {
    return UserWidget(user, me);
  }
}
