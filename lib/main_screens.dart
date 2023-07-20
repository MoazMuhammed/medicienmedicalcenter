import 'package:flutter/material.dart';
import 'package:medicienmedicalcenter/favorit_screen.dart';
import 'package:medicienmedicalcenter/home_screen.dart';
import 'package:medicienmedicalcenter/whatsapp_screen.dart';

class MainScreens extends StatefulWidget {
  const MainScreens({Key? key}) : super(key: key);

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {




  List<Widget> screens = [
    HomeScreen(),
    const WhatsappScreen(),
    const FavoriteScreen(),

  ];

  int index = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF42A5F5),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white30,
          onTap: (value) {
            print(index);
            index = value;
            setState(() {});
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_max_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.whatsapp), label: "Whatsapp"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outlined), label: "Favorite"),
          ]),

      body: screens[index],
    );
  }
}
