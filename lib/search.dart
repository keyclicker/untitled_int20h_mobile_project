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

  static User u = User(nick: "alex_rain992", age: 26, url:"https://biografii.net/wp-content/uploads/2018/11/1440161941-aleksandr-revva.jpg");
  static User u1 = User(nick: "TerMiNaToRRR_ala", age: 12, url:"https://prm.ua/wp-content/uploads/2019/03/terminator-1024x576.jpg");
  static User u2 = User(nick: "kaleo1998", age: 22, url:"http://radarmag.ru/wp-content/uploads/2018/07/2018.07.29-Kaleo-A2-24.jpg");
  static User u3 = User(nick: "nadia_alladin", age: 18, url: "https://thoughtcatalog.files.wordpress.com/2018/05/questionstoaskagirl2.jpg?w=1920&h=1280&crop=1&resize=1920,1280&quality=95&strip=all");
  static User me = User(nick: "igor", age: 31);
  List<User> allUsers = [u, u1, u2, u3];

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
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return new FlatButton(
                        child: MiniUserWidget(items[index]),
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

