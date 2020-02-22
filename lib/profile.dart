import 'package:flutter/material.dart';
import 'user.dart';
import 'activity.dart';



class Profile extends StatefulWidget {
  User me;
  User user;

  Profile(User me, User user){
    this.me = me;
    this.user = user;

  }

  @override
  _ProfileState createState() => _ProfileState(me, user);
}

class _ProfileState extends State<Profile> {
  User user;
  User me;

  _ProfileState(User me, User user){
    this.user = user;
    this.me = me;
  }

  @override
  Widget build(BuildContext context) {
    return UserWidget(user, me);
  }
}
