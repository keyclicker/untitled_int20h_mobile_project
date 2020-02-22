import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class MiniUser {
  User user;
  MiniUser(User _user) {
    this.user = _user;
  }

}

class MiniUserWidget extends StatefulWidget {
  MiniUser miniUser;
  MiniUserWidget(MiniUser _miniuser) {
    this.miniUser = _miniuser;
  }

  @override
  _MiniUserState createState() => _MiniUserState(this.miniUser);
}

class _MiniUserState extends State<MiniUserWidget>{
  MiniUser miniUser;
  _MiniUserState(MiniUser _miniUser) {
    this.miniUser = _miniUser;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image(
              image: NetworkImage(this.miniUser.user.imageUrl),
            ),
            title: Text(this.miniUser.user.nickname),
          ),
        ],
      ),
    );
  }
}

