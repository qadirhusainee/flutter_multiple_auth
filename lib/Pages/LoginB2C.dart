import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:serverx_poc/Pages/LoginAd.dart';

import 'package:serverx_poc/utils/AzureB2CConfig.dart';

class LoginB2C extends StatefulWidget {
  static final String route = 'LoginB2C';
  @override
  _LoginB2CState createState() => _LoginB2CState();
}

class _LoginB2CState extends State<LoginB2C> {
  bool _isBusy = false;
  String token;
  String accessToken;
  DateTime expiry;
  String refreshToken;
  bool isLoading = false;

  final FlutterAppAuth _appAuth = FlutterAppAuth();

  void setBusyState() {
    setState(() {
      _isBusy = true;
    });
  }

  _login() async {
    AuthorizationTokenResponse result;
    try {
      result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
            AzureB2CConfig.clientId, AzureB2CConfig.redirectUrl,
            issuer:
                'https://login.microsoftonline.com/068a0e5a-3b47-430c-9cf3-4036ad450338/v2.0',
            // discoveryUrl: AzureB2CConfig.discoveryUrl,
            scopes: AzureB2CConfig.scopes),
      );
    } catch (error) {
      print("Login error ${error.toString()}");
    }
    setState(() {
      token = result.idToken;
      accessToken = result.accessToken;
      expiry = result.accessTokenExpirationDateTime;
      refreshToken = result.refreshToken;
    });
    // var idToken = result.accessToken;
    final graphResponse = await http.get('https://graph.microsoft.com/v1.0/me',
        headers: {HttpHeaders.authorizationHeader: "Bearer ${result.idToken}"});
    print(graphResponse.body);

    print(result.authorizationAdditionalParameters.keys.length);
    print(result.accessToken);
  }

  _getUserDetails(token) async {
    setState(() {
      isLoading = true;
    });
    try {
      final graphResponse = await http.get(
          'https://graph.microsoft.com/v1.0/me',
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      print(graphResponse.body);
      // setState(() {
      //   userDetails = json.decode(graphResponse.body);
      // });
    } catch (error) {
      print(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _addItem() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
          'https://azureadappservice.azurewebsites.net/api/todolist',
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'Title': 'Flutter',
            'Owner': 'Flutter app',
          }));

      // setState(() {
      //   _customApiResponse = json.decode(response.body);
      // });
      print("success ${response.body}");
      print("code ${response.statusCode}");
    } catch (error) {
      print("Error $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Azure B2C"),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: isLoading,
                child: const LinearProgressIndicator(),
              ),
              RaisedButton(
                onPressed: () {
                  _login();
                },
                child: Text('Login'),
              ),
              accessToken != null
                  ? RaisedButton(
                      onPressed: () {
                        _getUserDetails(accessToken);
                      },
                      child: Text('Get User details'),
                    )
                  : Container(),
              accessToken != null
                  ? RaisedButton(
                      onPressed: () {
                        _addItem();
                      },
                      child: Text('Add Item'),
                    )
                  : Container(),
              Text(
                'TokenId',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(token ?? 'No Token',
                  style: TextStyle(color: Colors.black45, fontSize: 10)),
              SizedBox(height: 10),
              Text(
                'AccessToken',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(accessToken ?? 'No access Token',
                  style: TextStyle(color: Colors.black45, fontSize: 10)),
              SizedBox(height: 10),
              Text(
                'Refresh Token',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(refreshToken ?? 'Refresh Token',
                  style: TextStyle(color: Colors.black45, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Azure AD'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(LoginAd.route);
            },
          ),
        ],
      ),
    );
  }
}
