import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PgDialog {
  void progressStart(context) async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true,
        customBody: Container(
          margin: EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cached_rounded,
                size: 50,
              ),
              SizedBox(
                width: 25,
              ),
              Text(
                'Cargando...',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ));
    await pr.show();
  }

  void progressStop(context) async {
    ProgressDialog pr = ProgressDialog(context);
    await pr.hide();
  }
}
