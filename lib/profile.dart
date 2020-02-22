import 'package:flutter/material.dart';
import 'user.dart';
import 'activity.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = User("oleksii", 19);
  User me = User("sasha", 20);

  @override
  Widget build(BuildContext context) {
    return UserWidget(user, me);
  }
}
