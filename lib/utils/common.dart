import 'package:flutter/material.dart';

bool equals(a, b, c, bool nullCheck){
  return a == b && a == c && (nullCheck ? a != null : true);
}

void showLoadingDialog(BuildContext context){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          content: ListTile(
            title: Text('Loading...'),
            leading: CircularProgressIndicator(),
          )
      )
  );
}

void showAlertDialog({
  context: BuildContext,
  dismissible: bool,
  content: String,
  leading: Widget
})
{
  showDialog(
      barrierDismissible: dismissible ?? false,
      context: context,
      builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(content),
            leading: leading,
          )
      )
  );
}

void showSnackBar({context: BuildContext, text: String}){
  // Fluttertoast.showToast(
  //     msg: "This is Center Short Toast",
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.black,
  //     textColor: Colors.white,
  //     fontSize: 16.0
  // );

  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(fontSize: 30),),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}