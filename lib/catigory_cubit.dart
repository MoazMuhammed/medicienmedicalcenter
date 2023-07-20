import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sqflite.dart';

part 'catigory_state.dart';

class CatigoryCubit extends Cubit<CatigoryState> {
  CatigoryCubit() : super(CatigoryInitial());


  late Database database;
  var firestore = FirebaseFirestore.instance;
  var firrestore = FirebaseFirestore.instance;
  List<Map> items = [];
  List<Map> favorites = [];
  List<Map> carts = [];


  String uid = "";

  void insertmencare({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("mencare").collection("mencare").doc()
      .set({"id": id, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }
  void inserthealthandbeauty({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id1 = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id1.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("healthandbeauty").collection("healthandbeauty").doc()
      .set({"id": id1, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }
  void insertfirstaid({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id1 = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id1.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("firstaid").collection("firstaid").doc()
      .set({"id": id1, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }
  void insertchild({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id1 = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id1.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("child").collection("child").doc()
      .set({"id": id1, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }
  void insertteeth({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id1 = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id1.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("teeth").collection("teeth").doc()
      .set({"id": id1, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }
  void insertcorona({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id1 = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id1.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("corona").collection("corona").doc()
      .set({"id": id1, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }
  void insertmedicaltool({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id1 = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id1.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("medicaltool").collection("medicaltool").doc()
      .set({"id": id1, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }
  void insertpain({required String title, required String price, required String image,    required File file,}) async {
  // Insert some records in a transaction


  int id1 = DateTime.now().millisecondsSinceEpoch;


  final ref = FirebaseStorage.instance.ref().child("imageItems").child(id1.toString());

  await ref.putFile(file);

  final image = await ref.getDownloadURL();

  firestore
      .collection("category")
      .doc("pain").collection("pain").doc()
      .set({"id": id1, "title": title, "price": price,"image":image, "favorite": 0 });

  getContact();
  }

  void getContact() async {
  // items = await database.rawQuery('SELECT * FROM Item');
  print("List => : $items");

  firestore.collection("category").get().then((value) {
  items.clear();
  for(var document in value.docs){
  items.add(document.data());
  }
  emit(GetICatigoryStates());

  } );

  }



}
