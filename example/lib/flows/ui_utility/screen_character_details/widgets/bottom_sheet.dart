import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/utilities/app_assets.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

Future<dynamic> showAppBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    barrierColor: Colors.black87.withOpacity(0.5),
    isDismissible: false,
    enableDrag: false,
    builder: (context) => SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(AppAssets.rickMorty, height: 150),
            const Text('Approve to send request for a chat', style: labelStyle),
            _actionButtons(context),
          ],
        ),
      ),
    ),
  );
}

Column _actionButtons(BuildContext context) {
  return Column(
    children: [
      _sheetButton(context, 'Approve', () {
        Navigator.of(context).pop();
        _showSuccessToast('Chat request sent');
      }),
      const SizedBox(height: 10),
      _sheetButton(context, 'Request a weekly chat', () {
        Navigator.of(context).pop();
        _showWeeklyDialog(context);
      }),
      const SizedBox(height: 10),
      _sheetButton(context, 'Cancel', () {
        Navigator.of(context).pop();
      }),
    ],
  );
}

Widget _sheetButton(BuildContext context, String title, Function onClick) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    child: ElevatedButton(
      style: const ButtonStyle(
          side: MaterialStatePropertyAll(
              BorderSide(color: Colors.lightGreen, width: 1))),
      onPressed: () => onClick(),
      child: Text(title, style: buttonStyle),
    ),
  );
}

Future<dynamic> _showWeeklyDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const UEMarker(
                child: Text(
                    'Would you like to request a weekly chat with the character?')),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showSuccessToast('Weekly chat request sent');
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
            ],
          ));
}

void _showSuccessToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.lightGreen,
      textColor: Colors.white,
      fontSize: 16.0);
}
