import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class MiniUserWidget extends StatefulWidget {
  User user;
  MiniUserWidget(User _user) {
    this.user = _user;
  }

  @override
  _MiniUserState createState() => _MiniUserState(this.user);
}

class _MiniUserState extends State<MiniUserWidget>{
  User user;
  _MiniUserState(User _user) {
    this.user = _user;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image(
              image: NetworkImage(this.user.imageUrl),
            ),
            title: Text(this.user.nickname),
          ),
        ],
      ),
    );
  }
}

