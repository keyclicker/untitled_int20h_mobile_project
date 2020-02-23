import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

var host = 'http://217.61.1.129:8888/';
var client = http.Client();

class Achievement {
  String name;
  bool value;

  Achievement(String name, bool value)
  {
    this.name = name;
    this.value = value;
  }
}

class ActivityResponse {
  String category;
  String date;
  String time;
  String distanceValue;
  String distanceType;

  ActivityResponse(String category, int date, int time, int distance)
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

class HubResponse {
  String title;
  String category;
  List<String> members;

  HubResponse(String title, String category, List<String> members)
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

void follow(String follower, String user) async
{
  var followPost = await client.post(host + 'user/' + follower + '/following',
      body: convert.json.encode({'user': user}),
      headers: {'Content-Type': 'application/json'});
}

void unfollow(String follower, String user) async
{
  var followPost = await client.put(host + 'user/' + follower + '/following',
      body: convert.json.encode({'user': user}),
      headers: {'Content-Type': 'application/json'});
}

Future<List<String>> getFollowers(username) async
{
  var followersReq = await client.get(host + 'user/' + username + '/followers');
  var statusCode = followersReq.statusCode;
  if (statusCode == 200)
  {
    List<String> responseList = List<String>();
    for (var follower in convert.json.decode(followersReq.body)['list'])
    {
      responseList.add(follower);
    }
    return responseList;
  }
  else
  {
    return [];
  }
}

Future<List<String>> getFollowing(username) async
{
  var followingReq = await client.get(host + 'user/' + username + '/following');
  var statusCode = followingReq.statusCode;
  if (statusCode == 200)
  {
    List<String> responseList = List<String>();
    for (var following in convert.json.decode(followingReq.body)['list'])
    {
      responseList.add(following);
    }
    return responseList;
  }
  else
  {
    return [];
  }
}

Future<List<Achievement>> getAchievements(String username) async
{
  var achvmGet = await client.get(host + '/user/' + username + '/achievments');
  var statusCode = achvmGet.statusCode;
  if (statusCode == 200)
  {
    var responseList = List<Achievement>();
    for (var achievement in convert.json.decode(achvmGet.body)['list'].keys)
    {
      responseList.add(Achievement(achievement,
          convert.json.decode(achvmGet.body)['list'][achievement]));
    }
    return responseList;
  }
  else
  {
    return [];
  }
}

void addAchievement(String username, Achievement achievm) async
{
  var achvmPost = await client.post(host + 'user/' + username + '/achievements',
      headers: {"Content-Type": "application/json"},
      body: convert.json.encode({'name': true}));
}

Future<List<ActivityResponse>> getActivities(String username) async
{
  var actvtGet = await client.get(host + 'user/' + username + '/activities');
  var statusCode = actvtGet.statusCode;
  if (statusCode == 200)
  {
    List<ActivityResponse> responseList = List<ActivityResponse>();
    for (var activity in convert.json.decode(actvtGet.body)['list'])
    {
      responseList.add(ActivityResponse(activity['category'],
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

void addActivity(String username, String category, int time, int distance) async
{
  var achvmPost = client.post(host + 'user/' + username + '/activities',
      headers: {"Content-Type": "application/json"},
      body: convert.json.encode({'category': category,
        'date': DateTime.now().millisecondsSinceEpoch / 1000,
        'distance': distance}));
}

Future<ActivityResponse> getLastActivity(String username, String category) async
{
  List<ActivityResponse> listActivity = await getActivities(username);
  for (var activity in listActivity.reversed)
  {
    if (activity.category == category)
    {
      return activity;
    }
  }
  ActivityResponse emptyActivity = ActivityResponse(category, 0, 0, 0);

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

Future<List<HubResponse>> getHubs() async
{
  var hubsGet = await client.get(host + 'hubs');
  var statusCode = hubsGet.statusCode;
  if (statusCode == 200)
  {
    List<HubResponse> responseList = List<HubResponse>();
    for (var hub in convert.json.decode(hubsGet.body).keys)
    {
      responseList.add(HubResponse(hub,
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

Future<HubResponse> getHub(hub_name) async
{
  var hubsGet = await client.get(host + 'hubs/' + hub_name);
  var statusCode = hubsGet.statusCode;
  if (statusCode == 200)
  {
    print(convert.json.decode(hubsGet.body));
    var hub_info = HubResponse(hub_name,
        convert.json.decode(hubsGet.body)["category"],
        []);
    for (var member in convert.json.decode(hubsGet.body)['members'])
    {
      hub_info.members.add(member);
    }
    return hub_info;
  }
  else
  {
    return HubResponse("", "", []);
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

void main() async
{
  var a = await getHub("hackaton");
}