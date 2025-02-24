import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class LoadingDialog {
  static int count = 0;
  BuildContext context;
  LoadingDialog(this.context);

  showLoader(bool isCancellable) {
    final alert = Center(
      child: Container(
        padding: EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GifView.asset(
              "assets/gifs/fire-extinguisher.gif",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              frameRate: 30,
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: isCancellable,
      context: context,
      builder: (BuildContext context) {
        if (!isCancellable) {
          return WillPopScope(child: alert, onWillPop: () async => false);
        } else {
          return alert;
        }
      },
    );
    count++;
  }

  cancelLoader() {
    if (count > 0) {
      count--;
    } else {
      return;
    }
    Navigator.pop(context);
  }
}
