import 'package:flutter/material.dart';

class AlertWidget {
  final BuildContext context;
  String title = '';
  String content = '';
  Function callback;

  AlertWidget({
    Key key,
    @required this.context,
    @required this.title,
    @required this.content,
    @required this.callback,
  });
  Future show() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(title), Icon(Icons.info)]),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
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
                onPressed: () => callback(),
              )
            ],
          ));
}
