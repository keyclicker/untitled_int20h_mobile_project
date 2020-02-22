import 'package:flutter/material.dart';
import 'miniUser.dart';
import 'user.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
    ),
    home: new SearchPage()
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  static User u = User("sasha", 3);
  static User u1 = User("olega", 3);
  static User me = User("igor", 3);
  List<User> allUsers = [u, u1];

  List<String> duplicateItems = List<String>(); //= List<String>.generate(10000, (i) => "Item $i");
  var items = List<User>();

  _SearchPageState() {
    for (int i = 0; i < allUsers.length; i++) {
      duplicateItems.add(allUsers[i].nickname);
    }
  }

  @override
  void initState() {
    items.addAll(allUsers);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<User> dummySearchList = List<User>();
    dummySearchList.addAll(allUsers);
    if(query.isNotEmpty) {
      List<User> dummyListData = List<User>();
      dummySearchList.forEach((item) {
        if(item.nickname.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(allUsers);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                  child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return new FlatButton(
                        child:/*Text(items[index].nickname),*/ MiniUserWidget(items[index]),
                        onPressed: () {
                          UserWidget(items[index], me);
                        },
                      );
                    },
                  ),
                )

          ],
        ),
      ),
    );
  }
}

