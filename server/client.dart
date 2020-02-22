import 'dart:ffi';
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

var host = 'http://127.0.0.1:5000/';
var client = http.Client();

class Achievement {
  String title;
  String description;

  Achievement(String title, String description)
  {
    this.title = title;
    this.description = title;
  }
}

class Activity {
  String category;
  String date;
  String time;
  String distanceValue;
  String distanceType;

  Activity(String category, int date, int time, int distance)
  {
    this.category = category;
    var datetime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    this.date = DateFormat('H:m MMMM d').format(datetime);
    this.time = "${time ~/ 60}:${(time % 60) < 10 ? 0 : ''}${time % 60}";
    if (distance < 500)
    {
      this.distanceValue = distance.toString();
      this.distanceType = 'm';
    }
    else
    {
      this.distanceValue = (distance.toDouble() / 1000).toStringAsFixed(1);
      this.distanceType = 'km';
    }
  }
}

class Hub {
  String title;
  String category;
  List<String> members;

  Hub(String title, String category, List<String> members)
  {
    this.title = title;
    this.category = category;
    this.members = members;
  }
}

class UserInfo {
  String name;
  int age;
  String picture;

  UserInfo(String name, int age, String picture)
  {
    this.name = name;
    this.age = age;
    this.picture = picture;
  }
}

Future<bool> login(String username, String password) async
{
  var loginRequest = await client.post(host + 'login',
      body: convert.json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'});
  var statusCode = loginRequest.statusCode;
  if (statusCode == 200)
  {
    return true;
  }
  else
  {
    return false;
  }
}

Future<bool> follow(String follower, String user) async
{
  var followPost = await client.post(host + 'user/' + follower + '/following',
      body: convert.json.encode({'user': user}),
      headers: {'Content-Type': 'application/json'});
  var statusCode = followPost.statusCode;
  if (statusCode == 200)
  {
    return true;
  }
  else
  {
    return false;
  }
}

Future<bool> unfollow(String follower, String user) async
{
  var followPost = await client.put(host + 'user/' + follower + '/following',
      body: convert.json.encode({'user': user}),
      headers: {'Content-Type': 'application/json'});
  var statusCode = followPost.statusCode;
  if (statusCode == 200)
  {
    return true;
  }
  else
  {
    return false;
  }
}

Future<List<Achievement>> getAchievements(String username) async
{
  var achvmGet = await client.get(host + '/user/' + username + '/achievments');
  var statusCode = achvmGet.statusCode;
  if (statusCode == 200)
  {
    var responseList = List<Achievement>();
    for (var achievement in convert.json.decode(achvmGet.body)['list'])
    {
      responseList.add(Achievement(achievement.keys.first,
                                   achievement.values.first));
    }
    return responseList;
  }
  else
  {
    return [];
  }
}

Future<List<Activity>> getActivities(String username) async
{
  var actvtGet = await client.get(host + '/user/' + username + '/activities');
  var statusCode = actvtGet.statusCode;
  if (statusCode == 200)
  {
    List<Activity> responseList = List<Activity>();
    for (var activity in convert.json.decode(actvtGet.body)['list'])
    {
      responseList.add(Activity(activity['competition'],
                                activity['date'],
                                activity['time'],
                                activity['distance']));
    }
    return responseList;
  }
  else
  {
    return [];
  }
}

Future<Activity> getLastActivity(String username, String category) async
{
  List<Activity> listActivity = await getActivities(username);
  for (var activity in listActivity.reversed)
  {
    if (activity.category == category)
    {
      return activity;
    }
  }
  Activity emptyActivity = Activity(category, 0, 0, 0);

  emptyActivity.distanceType = '';
  emptyActivity.distanceValue = 'N/A';
  emptyActivity.time = 'N/A';
  emptyActivity.date = 'N/A';
  return emptyActivity;
}

Future<List<String>> getUserHubs(String username) async
{
  var hubsGet = await client.get(host + '/user/' + username + '/hubs');
  var statusCode = hubsGet.statusCode;
  if (statusCode == 200)
  {
    List<String> responseList = List<String>();
    for (var hub in convert.json.decode(hubsGet.body)['list'])
    {
      responseList.add(hub);
    }
    return responseList;
  }
  else
  {
    return [];
  }
}

Future<List<Hub>> getHubs() async
{
  var hubsGet = await client.get(host + 'hubs');
  var statusCode = hubsGet.statusCode;
  if (statusCode == 200)
  {
    List<Hub> responseList = List<Hub>();
    for (var hub in convert.json.decode(hubsGet.body).keys)
    {
      responseList.add(Hub(hub,
                           convert.json.decode(hubsGet.body)[hub]['competition'],
                           []));
      for (var member in convert.json.decode(hubsGet.body)[hub]['members'])
      {
        responseList.last.members.add(member);
      }
    }
    return responseList;
  }
  else
  {
    return [];
  }
}

Future<UserInfo> getUserInfo(String username) async
{
  var infoGet = await client.get(host + '/user/' + username + '/information');
  var statusCode = infoGet.statusCode;
  if (statusCode == 200)
  {
    return UserInfo(convert.json.decode(infoGet.body)['name'],
                    convert.json.decode(infoGet.body)['age'],
                    convert.json.decode(infoGet.body)['picture']);
  }
  else
  {
    return UserInfo('', 0, '');
  }
}