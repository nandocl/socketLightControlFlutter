import 'package:flutter/material.dart';

import 'package:front/src/states/state.notify.dart' as streamService;
import '../services/socket.service.dart' as socketService;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final socketStream = streamService.stream;

  @override
  void initState() {
    super.initState();
    checker();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pushNamed(context, 'menu');
              }),
        ),
        body: Center(
          child: Text('Sett'),
        ),
      ),
    );
  }

  void checker() {
    print('checker settings');
    socketStream.listen((event) {
      print('state luz ' + event.toString());
      if (event == false) {
        // Navigator.pushNamed(context, 'home');
      }
    });
  }

  void goBack() {
    socketService.stopListeners('settings');
    print('stopping luz');
    Navigator.pushNamed(context, 'menu');
    // Navigator.pushNamedAndRemoveUntil(context, 'menu', (route) => false);
  }
}
