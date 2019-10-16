import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'package:flutter/material.dart';
import 'picture.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user;
  bool isLoad = false;
  bool pictureLoad = false;
  bool feedLoad = false;
  int _selectedIndex = 0;
  Picture feed;
  Profile picture;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Picture> getFeed() async {
    final String feedUrl = 'https://api.imgur.com/3/gallery/hot/viral/day/1';
    final String feedHeader = 'Client-ID' + ' 011ada7e4889a21';

    final feedResponse = await http.get(
      feedUrl, headers: {HttpHeaders.authorizationHeader: feedHeader}
    );
    if (feedResponse.statusCode == 200) {
      return Picture.fromJson(json.decode(feedResponse.body));
    } else {
      return null;
    }
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = 'https://api.imgur.com/3/account/' + prefs.getString('account_username');
    final String header = 'Client-ID' + ' 011ada7e4889a21';

    final response = await http.get(
        url, headers: {HttpHeaders.authorizationHeader: header}
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)['data']);
    } else {
      return null;
    }
  }

  Future<Profile> getPicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String pictureUrl = 'https://api.imgur.com/3/account/me/images';
    final String pictureHeader = 'Bearer ' + prefs.getString('access_token');
    
    final pictureResponse = await http.get(
      pictureUrl, headers: {HttpHeaders.authorizationHeader: pictureHeader}
    );
    if (pictureResponse.statusCode == 200) {
      return Profile.fromJson(json.decode(pictureResponse.body));
    } else {
      return null;
    }
  }

  Future<void> getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token');
    String expiresIn = prefs.getString('expires_in');
    String refreshToken = prefs.getString('refresh_token');
    String accountUsername = prefs.getString('account_username');
    String accountId = prefs.getString('account_id');
    setState(() {
      isLoad = true;
    });
  }

  void getData() async {
    getUser().then((User user) {
      if (user == null) {
        // Error
      }
      setState(() {
        this.user = user;
      });
    });
  }
  
  void receivePicture() async {
    getPicture().then((Profile picture) {
      if (picture == null) {
        // Error
      }
      setState(() {
        this.picture = picture;
      });
    });
  }

  void receiveFeed() async {
    getFeed().then((Picture feed) {
      if (feed == null) {
        // Error
      }
      setState(() {
        this.feed = feed;
      });
    });
  }

  Widget buildPicture(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 300,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: picture.pictureList.length,
        itemBuilder: (context, index) {
            return new Image.network(picture.pictureList[index].link);
        },
      ),
    );
  }

  Widget search(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar.builder(
        itemCount: feed.pictureList.length,
        itemBuilder: (BuildContext context, int index) {
          if (feed.pictureList[index].photoList != null && feed.pictureList[index].photoList[0].type != 'video/mp4') {
            return new Image.network(
                feed.pictureList[index].photoList[0].link);
          } else {
            return new Container();
          }
        },
        trailing: CircleAvatar(
          child: Text('RD'),
        ),
        onChanged: (String value) {},
        onTap: () {},
        decoration: InputDecoration.collapsed(
          hintText: "Search...",
        ),
      ),
    );
  }

  Widget home(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: feed.pictureList.length,
            itemBuilder: (context, index) {
              if (feed.pictureList[index].photoList != null && feed.pictureList[index].photoList[0].type != 'video/mp4') {
                return new Image.network(
                    feed.pictureList[index].photoList[0].link);
              } else {
                return new Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget profile(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    child: Image.network(user.avatar, scale: 3, alignment: Alignment.center,)
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(user.bio),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Divider(thickness: 1,),
                ),
                buildPicture(context),
              ],
          ),
        ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getValues();
    getData();
    receivePicture();
    receiveFeed();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoad == false || this.user == null || this.picture == null || this.feed == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    }
    List<Widget> listArray = [
      home(context),
      search(context),
      profile(context),
    ];
    return Scaffold(
      body: Center(
        child: listArray[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait),
            title: Text('Profile'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black87,
      ),
    );
  }
}