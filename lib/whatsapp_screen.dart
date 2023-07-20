import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WhatsappScreen extends StatelessWidget {
  const WhatsappScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildOpenWhatsapp(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Tap on icon for sending message to us ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(
      icon: Icon(Icons.facebook),color: Colors.blue,
      iconSize: 80.0,
      onPressed: () {
        var url = "https://www.facebook.com";
        launchUrlString(url);
      },
    ),IconButton(
      icon: Icon(Icons.alternate_email),color: Colors.redAccent,
      iconSize: 80.0,
      onPressed: () {
        var url = "https://www.gmail.com";
        launchUrlString(url);
      },
    ),
  ],
)

                ],
              ),
            )));
  }
}

Widget buildOpenWhatsapp() {
  return Stack(
    alignment: Alignment.center,
    children: [
      const CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
      ),
      const CircleAvatar(
        radius: 70,
        backgroundColor: Color.fromRGBO(53, 172, 210, 100),
      ),
      IconButton(
        icon: Image.asset("lib/images/whatsapp.png"),
        iconSize: 80.0,
        onPressed: () {
          var url = "whatsapp://send?phone=+2001032006235";
          launchUrlString(url);
        },
      ),
    ],
  );
}
