import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class Setting extends StatefulWidget {

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String url = "https://www.guessinggames.co/privacy-policy.html";

  Future<void> _openInBrowser() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: (){
             _openInBrowser();
            },
            child: 
            Card(
              child: ListTile(
                title: Text("Privacy Policy"),
                trailing: Icon(Icons.arrow_forward_ios),

              ),
            ),
          )
        ],
      ),
    );
  }
}
