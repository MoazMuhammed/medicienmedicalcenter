import 'package:flutter/material.dart';

class MyButtom extends StatelessWidget {
   MyButtom({Key? key, required this.onPressed, required this.data}) : super(key: key);
  final VoidCallback onPressed;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(data),
      ),
    );
  }
}
