import 'package:flutter/material.dart';
import 'package:front/src/states/state.notify.dart' as streamService;

import '../widgets/progDialog.widget.dart';

import '../services/http.service.dart' as httpService;
import '../services/socket.service.dart' as socketService;
import '../utils/menu.items.util.dart' as menuItemsInfo;
import '../utils/tokenHandler.util.dart' as tokenUtil;
import '../widgets/alert.widget.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final socketStream = streamService.stream;
  var socketChecker;

  @override
  void initState() {
    checker();
    super.initState();
  }

  @override
  void dispose() {
    socketChecker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    AlertWidget(
                        context: context,
                        title: 'Esta a punto de salir',
                        content: 'Se terminara la sesion en este dispositivo.',
                        callback: () {
                          socketService.socketDisconnect();
                          tokenUtil.removeTokenInStorage();
                          Navigator.pushNamed(context, 'home');
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, 'home', (route) => false);
                        }).show();
                  }),
            ],
          ),
          body: FutureBuilder(
              future: httpService.mainMenu(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      padding: EdgeInsets.all(15),
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 3 : 4),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> itm =
                            menuItemsInfo.manuItem(snapshot.data[index]);
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(7),
                            padding: EdgeInsets.all(20),
                            color: itm['backColor'],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  itm['icon'],
                                  size: 40,
                                  color: itm['textColor'],
                                ),
                                Text(
                                  itm['text'],
                                  style: TextStyle(
                                      color: itm['textColor'], fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Navigator.pushNamed(context, itm['route']);
                            Navigator.pushNamedAndRemoveUntil(
                                context, itm['route'], (route) => false);
                          },
                        );
                      });
                }
                return Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cached_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Cargando...'),
                  ],
                ));
              })),
    );
  }

  void checker() {
    print(socketService.conected);
    if (!socketService.conected)
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    socketChecker = socketStream.listen((event) {
      print('state menu ' + event.toString());
      if (event == false) {
        // Navigator.pushNamed(context, 'home');
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      }
    });
  }
}
