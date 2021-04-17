import 'package:front/src/models/light.model.dart';
import 'package:front/src/states/state.notify.dart' as streamService;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../streams/luz.stream.dart' as luzStream;

IO.Socket socket;
bool conected = true;

socketConnect(String token) {
  socket = IO.io(
      'http://192.168.1.100:3000',
      IO.OptionBuilder()
          .setTimeout(3000)
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .setQuery({'token': token})
          .build());

  //Events handler
  socket.onConnectError((data) {
    socketDisconnect();
    print('ce');
  });
  socket.onDisconnect((data) {
    socketDisconnect();
    print('dc');
  });

  //Listeners
  socket.onConnect((_) {
    conected = true;
    streamService.updateSocketState(true);
  });
  socket.connect();
}

///////Emiters
//Luz
void updateLuzState(LuzModel luzItem) {
  socket.emit('updateLuzState', luzItem);
}

//Funciones
void socketDisconnect() {
  print('forceDisconn');
  socket.close();
  socket.disconnect();
  socket.dispose();
  conected = false;
  streamService.updateSocketState(false);
}

void stopListeners(String event) {
  String realName = '';
  switch (event) {
    case 'luz':
      realName = 'updateLuzState';
      break;
    case 'settings':
      realName = 'updateSettingsState';
      break;
  }
  socket.off(realName);
}

void listenEvent(String event) {
  if (conected) {
    if (event == 'luz') {
      socket.on('updateLuzState', (data) {
        luzStream.updateItemState(data);
      });
    }
  }
}
