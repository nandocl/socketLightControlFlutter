import 'dart:async';

import 'package:front/src/models/light.model.dart';
import 'package:front/src/services/http.service.dart' as http;

List<LuzModel> _luzList = [];

final _listLuzStreamController = StreamController<List<LuzModel>>.broadcast();

//Se escucha desde streamBuilder
Stream<List<LuzModel>> get luzListStream => _listLuzStreamController.stream;

Function(List<LuzModel>) get luzListSink {
  return _listLuzStreamController.sink.add;
}

//Init lista de luces
void initLuzList() async {
  _luzList = await http.getAllLuz();
  if (_luzList != null) luzListSink(_luzList);
}

//Cambiar un item
void updateItemState(newItemState) async {
  List<LuzModel> newLuzList = [];
  _luzList.forEach((element) {
    if (element.id == newItemState['id']) {
      element.state = newItemState['state'];
      element.name = newItemState['name'];
    }
    newLuzList.add(element);
  });
  _luzList = newLuzList;
  luzListSink(_luzList);
}

void dispose() {
  _listLuzStreamController?.close();
}
