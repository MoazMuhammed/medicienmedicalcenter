import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:medicienmedicalcenter/auth_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:medicienmedicalcenter/catigory_cubit.dart';
import 'package:medicienmedicalcenter/home_screen.dart';
import 'package:medicienmedicalcenter/item_cubit.dart';
import 'package:medicienmedicalcenter/login_screen.dart';
import 'package:medicienmedicalcenter/main_screens.dart';
import 'package:medicienmedicalcenter/whatsapp_screen.dart';
import 'package:provider/provider.dart';
final auth = FirebaseAuth.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authent>(
          create: (_) => Authent(FirebaseAuth.instance),
        ),Provider<ItemCubit>(
          create: (_) => ItemCubit(),
        ),Provider<CatigoryCubit>(
          create: (_) => CatigoryCubit(),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
          context
              .read<Authent>()
              .authState,
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: auth.currentUser == null?  LoginScreen():MainScreens(),
        ),
    );
  }
}


