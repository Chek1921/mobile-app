import 'package:flutter/material.dart';
import 'package:mobileapp/api/api_connect.dart';
import 'package:mobileapp/pages/bills/bills.dart';
import 'package:mobileapp/pages/news/news.dart';
import 'package:mobileapp/pages/receipts/receipts.dart';
import 'package:mobileapp/pages/report/reports.dart';
import 'report/create_report.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(top:50.0,left: 20.0),

            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "ЖКХ",
                  style:TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.lightBlue[300],
                  ),
                  //textAlign: TextAlign.left,
                ),

              ],
            ),

          ),

        ),
        SizedBox(
          height: 20.0,
        ),
        ListTile(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => NewsPage()));
          },
          leading: Icon(
            Icons.newspaper,
            color: Colors.black,
          ),
          title:Text(
              "Новости"
          ),

        ),
        ListTile(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CreateReport()));
          },
          leading: Icon(
            Icons.report,
            color: Colors.black,
          ),
          title:Text(
              "Написать жалобу"
          ),

        ),
        ListTile(
          onTap: (){
            refreshToken();
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => BillsPage()));
          },
          leading: Icon(
            Icons.payments,
            color: Colors.black,
          ),
          title:Text(
              "Счета"
          ),

        ),ListTile(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ReportsPage()));
          },
          leading: Icon(
            Icons.folder_copy,
            color: Colors.black,
          ),
          title:Text(
              "Мои жалобы"
          ),

        ),ListTile(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ReceiptsPage()));
          },
          leading: Icon(
            Icons.receipt_long,
            color: Colors.black,
          ),
          title:Text(
              "Квитанции"
          ),
        ),
      ],
    );
  }
}