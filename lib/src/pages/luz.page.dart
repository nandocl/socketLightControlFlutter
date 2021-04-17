import 'package:flutter/material.dart';

import 'package:front/src/models/light.model.dart';
import 'package:front/src/streams/luz.stream.dart' as luzStream;
import '../services/socket.service.dart' as socketService;
import 'package:front/src/states/state.notify.dart' as streamService;

class LuzPage extends StatefulWidget {
  @override
  _LuzPageState createState() => _LuzPageState();
}

class _LuzPageState extends State<LuzPage> {
  final socketStream = streamService.stream;
  TextEditingController _nombreCtrl = new TextEditingController();
  var socketChecker;

  @override
  void initState() {
    luzStream.initLuzList();
    socketService.listenEvent('luz');
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
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return;
      },
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Luces'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  goBack();
                }),
          ),
          body: StreamBuilder(
              stream: luzStream.luzListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.all(15),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return luzItem(snapshot.data[index]);
                      });
                } else {
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
                }
              }),
        ),
      ),
    );
  }

  Widget luzItem(itemData) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(top: 5, bottom: 30, right: 10, left: 10),
        color: Colors.yellow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Icon(
                    Icons.edit_outlined,
                    size: 28,
                  ),
                  onTap: () {
                    updateLuzNamePop(itemData);
                  },
                )),
            Icon(
              itemData.state == true
                  ? Icons.lightbulb
                  : Icons.lightbulb_outline,
              size: 45,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              itemData.name,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
      onTap: () {
        itemData.state = !itemData.state;
        socketService.updateLuzState(itemData);
      },
    );
  }

  updateLuzNamePop(LuzModel itemData) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Modificar "' + itemData.name + '"'),
              content: TextFormField(
                controller: _nombreCtrl..text = itemData.name,
                decoration: InputDecoration(hintText: 'Nuevo nombre.'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      _nombreCtrl.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0),
                    ),
                  ),
                  child: Text('Aceptar'),
                  onPressed: () {
                    itemData.name = _nombreCtrl.text;
                    socketService.updateLuzState(itemData);
                    _nombreCtrl.clear();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  void goBack() {
    _nombreCtrl.dispose();
    socketService.stopListeners('luz');
    print('stopping luz');
    // Navigator.pushNamed(context, 'menu');
    Navigator.pushNamedAndRemoveUntil(context, 'menu', (route) => false);
  }

  void checker() {
    print('checker luz');
    socketChecker = socketStream.listen((event) {
      print('state luz ' + event.toString());
      if (event == false) {
        // Navigator.pushNamed(context, 'home');
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      }
    });
  }
}
