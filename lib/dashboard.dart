import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'package:flutter/material.dart';
import 'picture.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user;
  bool isLoad = false;
  bool pictureLoad = false;
  int _selectedIndex = 0;
  Picture picture;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  Future<Picture> getPicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String pictureUrl = 'https://api.imgur.com/3/account/me/images';
    final String pictureHeader = 'Bearer ' + prefs.getString('access_token');
    
    final pictureResponse = await http.get(
      pictureUrl, headers: {HttpHeaders.authorizationHeader: pictureHeader}
    );
    if (pictureResponse.statusCode == 200) {
      return Picture.fromJson(json.decode(pictureResponse.body));
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
    getPicture().then((Picture picture) {
      if (picture == null) {
        // Error
      }
      setState(() {
        this.picture = picture;
      });
    });
  }

  Widget buildPicture() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Text(picture.pictureList[index].link)
          ],
        );
      },
    );
  }

  Widget profile(BuildContext context) {
    if (isLoad == false || this.user == null) {
      return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          )
      );
    }
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
                Container(
                  child: Image.network(picture.pictureList[1].link),
                ),
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
  }

  @override
  Widget build(BuildContext context) {
    if (isLoad == false || this.user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    }
    List<Widget> listArray = [
      Text(
          'Index 0: Home'
      ),
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