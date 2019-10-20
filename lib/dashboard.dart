import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'picture.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';

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
  var myController = TextEditingController();
  Picture research;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Picture> getFeed() async {
    final String feedUrl = 'https://api.imgur.com/3/gallery/hot/viral/day/1';
    final String feedHeader = 'Client-ID' + ' 011ada7e4889a21';

    final feedResponse = await http
        .get(feedUrl, headers: {HttpHeaders.authorizationHeader: feedHeader});
    if (feedResponse.statusCode == 200) {
      return Picture.fromJson(json.decode(feedResponse.body));
    } else {
      return null;
    }
  }

  Future<Picture> getSearch() async {
    String test = myController.text;
    final String searchUrl =
        'https://api.imgur.com/3/gallery/search/?q=' + test;
    final String searchHeader = 'Client-ID' + ' 011ada7e4889a21';

    final searchResponse = await http.get(searchUrl,
        headers: {HttpHeaders.authorizationHeader: searchHeader});
    if (searchResponse.statusCode == 200) {
      return Picture.fromJson(json.decode(searchResponse.body));
    } else {
      return null;
    }
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = 'https://api.imgur.com/3/account/' +
        prefs.getString('account_username');
    final String header = 'Client-ID' + ' 011ada7e4889a21';

    final response =
        await http.get(url, headers: {HttpHeaders.authorizationHeader: header});
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

    final pictureResponse = await http.get(pictureUrl,
        headers: {HttpHeaders.authorizationHeader: pictureHeader});
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

  void receiveSearch() async {
    getSearch().then((Picture research) {
      if (research == null) {
        // Error
      }
      setState(() {
        this.research = research;
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
          return new Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: FittedBox(
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: CachedNetworkImageProvider(
                      picture.pictureList[index].link),
                ),
                fit: BoxFit.fill,
              ));
        },
      ),
    );
  }

  Widget search(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: TextFormField(
            controller: myController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Search',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                receiveSearch();
              },
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: research.pictureList.length,
            itemBuilder: (context, index) {
              if (research.pictureList[index].photoList != null &&
                  research.pictureList[index].photoList[0].type !=
                      'video/mp4') {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: FittedBox(
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/placeholder.png'),
                        image: CachedNetworkImageProvider(
                          research.pictureList[index].photoList[0].link,
                          targetWidth:
                              MediaQuery.of(context).size.width.toInt(),
                        ),
                      ),
                      fit: BoxFit.fill,
                    ));
              } else {
                return new Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget home(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Epicture'),
          backgroundColor: Colors.grey[900],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: feed.pictureList.length,
            itemBuilder: (context, index) {
              if (feed.pictureList[index].photoList != null &&
                  feed.pictureList[index].photoList[0].type != 'video/mp4') {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: FittedBox(
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/placeholder.png'),
                        image: CachedNetworkImageProvider(
                          feed.pictureList[index].photoList[0].link,
                          targetWidth:
                              MediaQuery.of(context).size.width.toInt(),
                        ),
                      ),
                      fit: BoxFit.fill,
                    ));
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
        appBar: AppBar(
          title: Text(user.url),
          backgroundColor: Colors.grey[900],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/placeholder.png'),
                    image: CachedNetworkImageProvider(user.avatar),
                    width: 100,
                    height: 100,
                  )),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  user.bio,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
              buildPicture(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getValues();
    getData();
    receivePicture();
    receiveFeed();
    receiveSearch();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoad == false ||
        this.user == null ||
        this.picture == null ||
        this.feed == null) {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
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
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
