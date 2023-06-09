import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/models/news.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/pages/news/new.dart';
import 'package:mobileapp/services/storage.dart';

class NewsPage extends StatefulWidget {
  final HomeController _homeController = HomeController();
  @override
  _NewsPageState createState() => _NewsPageState();

  
}

class _NewsPageState extends State<NewsPage> {
  List<News> _listNews = [];

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    widget._homeController.getNews().then((listNews) {
      setState(() {
        _listNews = listNews;
      });
    });
  }

  final SecureStorage storage = SecureStorage();
  String buttonText = '';
  String? _username = '';

  Future<String?> getUsername() async {
    _username = await storage.getUsername();
    return _username;
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
      body: ListView.builder(
        itemCount: _listNews.length,
        itemBuilder: (context, index) {
          final itemNews = _listNews[_listNews.length-index-1];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.cyan[100],
            child: Column(
              children: [
                Text(itemNews.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                Text(itemNews.text, overflow: TextOverflow.ellipsis, maxLines: 4, textAlign: TextAlign.left,),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: OutlinedButton(
                  onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage(page: itemNews.id)))
                    },
                  child: Text('Подробнее', style: TextStyle(color: Colors.black),),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                  '${itemNews.timeCreate.split('-')[2].split('T')[0]}.${itemNews.timeCreate.split('-')[1]}.${itemNews.timeCreate.split('-')[0]}г.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.right,
                    ),
                ),
              ],
              ),
          );
        },
      ),
    );
  }
}
