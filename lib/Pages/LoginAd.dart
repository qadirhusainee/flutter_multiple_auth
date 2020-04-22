import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:serverx_poc/Pages/LoginB2C.dart';

import 'package:serverx_poc/utils/AzureAdConfig.dart';

class LoginAd extends StatefulWidget {
  static String route = 'LoginAd';
  @override
  _LoginAdState createState() => _LoginAdState();
}

class _LoginAdState extends State<LoginAd> {
  String accessToken;
  bool isLoading = false;
  String _customApiResponse;
  var userDetails;
  var _todoList;
  final todoController = TextEditingController();
  _login() async {
    try {
      setState(() {
        isLoading = true;
      });
      await AzureAdConfig.oauth.logout();
      await AzureAdConfig.oauth.login();
      String result = await AzureAdConfig.oauth.getAccessToken();
      bool isValid = AzureAdConfig.oauth.tokenIsValid();
      print('isValid $isValid');
      setState(() {
        accessToken = result;
        isLoading = false;
      });
      _getUserDetails(result);
    } catch (error) {
      print(error.toString());
      setState(() {
        isLoading = false;
      });
    }
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
      setState(() {
        userDetails = json.decode(graphResponse.body);
      });
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
            HttpHeaders.authorizationHeader: "Bearer $accessToken",
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'Title': todoController.text,
            'Owner': 'Flutter app',
          }));
      todoController.clear();
      print("success ${response.body}");
      print("code ${response.statusCode}");
      _getItem();
    } catch (error) {
      print("Error $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _getItem() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
          'https://azureadappservice.azurewebsites.net/api/todolist',
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken",
            'Content-Type': 'application/json; charset=UTF-8'
          });

      setState(() {
        _todoList = json.decode(response.body);
      });
      print("body ${response.body}");
      print("status ${response.statusCode}");
    } catch (error) {
      print("Error $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _logout() async {
    setState(() {
      isLoading = true;
    });
    await AzureAdConfig.oauth.logout();
    setState(() {
      userDetails = null;
      accessToken = null;
      isLoading = false;
    });
  }

  Widget table() {
    var todos = List.from(_todoList);
    return Table(
      columnWidths: {1: FractionColumnWidth(0.7), 2: FractionColumnWidth(0.3)},
      border: TableBorder.all(color: Colors.grey),
      children: todos.map((todo) {
        return TableRow(children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(todo['title'])),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                todo['owner'],
                style: TextStyle(fontSize: 9),
              )),
        ]);
      }).toList(),
    );
  }

  Widget inputContainer() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
          child: TextField(
            controller: todoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Input Todo',
            ),
          ),
        ),
        SizedBox(width: 10),
        RaisedButton(
          onPressed: () {
            if (todoController.text.isNotEmpty) {
              _addItem();
            }
          },
          child: Text('Add Item'),
        )
      ],
    );
  }

  Widget displayUserDetails() {
    if (userDetails != null) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Dsiplay Name: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["displayName"] ?? "No Data")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Email: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["mail"] ?? "No Data")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Id: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["id"] ?? "No Data")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Mobile Phone: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["mobilePhone"] ?? "No Data")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Job Title: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["jobTitle"] ?? "No Data")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Office Location: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["officeLocation"] ?? "No Data")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'User Principal Name: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["userPrincipalName"] ?? "No Data")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Preferred Language: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userDetails["preferredLanguage"] ?? "No Data")
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var rectSize =
        Rect.fromLTWH(0.0, 50.0, screenSize.width, screenSize.height - 50);
    AzureAdConfig.oauth.setWebViewScreenSize(rectSize);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(title: Text("Azure AD")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: isLoading,
                child: const LinearProgressIndicator(),
              ),
              accessToken == null
                  ? RaisedButton(
                      onPressed: () {
                        _login();
                      },
                      child: Text('Login'),
                    )
                  : Container(),
              accessToken != null
                  ? RaisedButton(
                      onPressed: () {
                        _logout();
                      },
                      child: Text('Logout'),
                    )
                  : Container(),
              accessToken != null
                  ? RaisedButton(
                      onPressed: () {
                        _getUserDetails(accessToken);
                      },
                      child: Text('Get user Details'),
                    )
                  : Container(),
              accessToken != null
                  ? RaisedButton(
                      onPressed: () {
                        _getItem();
                      },
                      child: Text('Get Item'),
                    )
                  : Container(),
              _customApiResponse != null
                  ? Text('Custom Api Response $_customApiResponse')
                  : Container(),
              SizedBox(height: 10),
              _todoList != null ? inputContainer() : Container(),
              SizedBox(
                height: 20,
              ),
              _todoList != null ? table() : Container(),
              // displayUserDetails(),
              SizedBox(height: 10),
              Text(
                'Access Token',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(accessToken ?? 'No Token',
                  style: TextStyle(color: Colors.black45, fontSize: 8)),
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
            title: Text('Azure B2C'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(LoginB2C.route);
            },
          ),
        ],
      ),
    );
  }
}
