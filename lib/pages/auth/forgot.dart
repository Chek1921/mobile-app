import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/pages/auth/login.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
  
  final HomeController _homeController = HomeController();
}

class _ForgotState extends State<Forgot> {
  TextEditingController emailController = TextEditingController();
  String error = '';
  dynamic color = Colors.amber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Восстановление пароля"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 30.0),

              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Почта',
                    hintText: 'Введите почту'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15
                  ),
              child: Text(error, style: TextStyle(color: color),),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  String email = emailController.text;
                  String _error = await widget._homeController.forgotUser(email);
                  if (_error == 'Введите правильный адрес электронной почты.') {
                    setState(() {
                      color = Colors.red;
                      error = _error;
                    });
                  } else {
                    setState(() {
                      color = Colors.green;
                      error = _error;
                    });
                  }
                },
                child: Text(
                  'Отправить',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Вход',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
