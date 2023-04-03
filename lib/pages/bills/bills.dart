import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/models/news.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/services/storage.dart';

class BillsPage extends StatefulWidget {
  final HomeController _homeController = HomeController();
  @override
  _BillsPageState createState() => _BillsPageState();

  
}

class _BillsPageState extends State<BillsPage> {
  List<News> _listNews = [];

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    getToken().then((String? token) {
      setState(() {
        _token = token.toString();
      });
    });
    getRefreshToken().then((String? refresh_token) {
      setState(() {
        _refresh_token = refresh_token.toString();
      });
    });
    widget._homeController.getNews().then((listNews) {
      setState(() {
        _listNews = listNews;
      });
    });
  }

  String? _token = '';
  String? _refresh_token = '';
  String? _username = '';

  final SecureStorage storage = SecureStorage();
  String buttonText = '';

  Future<String?> getUsername() async {
    _username = await storage.getUsername();
    return _username;
  }

  Future<String?> getToken() async {
    _username = await storage.getToken();
    return _token;
  }

  Future<String?> getRefreshToken() async {
    _refresh_token = await storage.getRefreshToken();
    return _refresh_token;
  }

  void UsernameUpdate() {
    getUsername().then((String? username) {
      setState(() {
        if (username == null) {
          buttonText = 'Вход';
        }
        else {
          _username = username.toString();
          buttonText = '(${_username})Выход';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('ЖКХ услуги'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                if (buttonText == '(${_username})Выход') {
                  storage.deleteData();
                  setState(() {
                    buttonText = 'Вход';
                  });
                }
                else {
                  Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Login()));
                }
              },
              child: Text(buttonText))
        ],
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: Column(
        children: [
          Text('токен: ${_token}'),

      ],)
      
      
      
      
      // ListView.builder(
      //   itemCount: _listNews.length,
      //   itemBuilder: (context, index) {
      //     final itemNews = _listNews[_listNews.length-index-1];
      //     return ListTile(
      //       tileColor: Colors.grey[400],
      //       title: Text(itemNews.title),
      //       subtitle: Text(
      //         itemNews.text,
      //         overflow: TextOverflow.ellipsis,
      //         maxLines: 2,
      //       ),
      //       trailing: const Icon(Icons.arrow_forward_rounded),
      //       onTap: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (_) => NewsPage()));
      //       },
      //     );
      //   },
      // ),
      );
     }
  }