import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:epicture/dashboard.dart';
import 'feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  String loginUrl = 'https://api.imgur.com/oauth2/authorize?client_id=011ada7e4889a21&response_type=token';
  bool isLoggedIn = false;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    getData();
  }

  void getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('access_token');
    print(stringValue);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          if (url.startsWith('https://app.getpostman.com/oauth2/callback')) {
            url = url.replaceAll('#', '?');
            Uri uri = Uri.parse(url);
            prefs.setString('access_token', uri.queryParameters['access_token']);
            prefs.setString('expires_in', uri.queryParameters['expires_in']);
            prefs.setString('refresh_token', uri.queryParameters['refresh_token']);
            prefs.setString('account_username', uri.queryParameters['account_username']);
            prefs.setString('account_id', uri.queryParameters['account_id']);
            flutterWebviewPlugin.close();
            //Navigator.pushNamed(context, '/dashboard');
            setState(() {
              this.isLoggedIn = true;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoggedIn) {
      return Dashboard();
    } else {
      return new WebviewScaffold(
        url: this.loginUrl,
        appBar: AppBar(
          title: Text('Epicture'),
          backgroundColor: Colors.black,
        ),
      );
    }
  }
}