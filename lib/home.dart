import 'package:flutter/material.dart';
import 'activities.dart';
import 'profile.dart';
import 'search.dart';
import 'user.dart';
import 'map.dart';


class MainPage extends StatefulWidget {
  User me;

  MainPage(User user){
    this.me = user;
  }

  @override
  _MainPageState createState() => _MainPageState(this.me);
}

class _MainPageState extends State<MainPage> {
  User me;

  _MainPageState(User authorisedUser){
    this.me = authorisedUser;
  }

  Widget widgetOption(int index) {
    if (index == 0) {
      return Activities();
    } else if (index == 1) {
      return Search();
    } else {
      return Profile(me, me);
    }
  }

  @override
  int _selectedIndex = 0;
  //static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  //static List<Widget> _widgetOptions = <Widget>[
    //Activities(),
    //Search(),
    //Profile()
  //];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOption(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            title: Text('Activities'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
