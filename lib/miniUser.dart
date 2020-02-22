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


  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: ClipRRect(
              child: Container(
                height: 50,
                width: 50,
                child: Image(
                  image: NetworkImage(user.imageUrl),
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            title: Text(this.user.nickname),
          ),
        ],
      ),
    );
  }
}

