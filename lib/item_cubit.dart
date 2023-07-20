import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicienmedicalcenter/item_statement.dart';
import 'package:sqflite/sqflite.dart';

class ItemCubit extends Cubit<ItemStates> {
  ItemCubit() : super(InitItemStates());

  late Database database;
  var firestore = FirebaseFirestore.instance;
  var firrestore = FirebaseFirestore.instance;
  List<Map> items = [];
  List<Map> favorites = [];
  List<Map> carts = [];

  Future<void> createDatabase() async {
    database = await openDatabase("item", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Item (id INTEGER PRIMARY KEY, title TEXT,  price TEXT, favorite INTEGER)');
    }, onOpen: (database) {
      print('OPENED');
    });
    getContact();
    getFavorites();
  }

  String uid = "";

  void insertContact({
    required String title,
    required String price,
    required String image,
    required File file,
  }) async {
    // Insert some records in a transaction

    int id1 = DateTime.now().millisecondsSinceEpoch;

    final ref = FirebaseStorage.instance
        .ref()
        .child("imageItems")
        .child(id1.toString());

    await ref.putFile(file);

    final image = await ref.getDownloadURL();

    firestore.collection("databaseProject").doc(id1.toString()).set({
      "id": id1,
      "title": title,
      "price": price,
      "image": image,
      "favorite": 0
    });

    getContact();
  }

  void getContact() async {
    // items = await database.rawQuery('SELECT * FROM Item');
    print("List => : $items");

    firestore.collection("databaseProject").get().then((value) {
      items.clear();
      for (var document in value.docs) {
        items.add(document.data());
      }
      emit(GetItemStates());
    });
  }

  void getFavorites() async {
    // favorites = await database.query("Item",
    //     columns: ["id", "title", "price", "favorite"],
    //     where: 'favorite = ?',
    //     whereArgs: [1]);

    await firestore
        .collection("databaseProject")
        .where("favorite", isEqualTo: 1)
        .get()
        .then((value) {
      favorites.clear();

      for (var document in value.docs) {
        favorites.add(document.data());
      }
    });

    emit(GetFavoritesItemStates());
  }

  Future<void> updateItem({
    required int favorite,
    required int id,
  }) async {
    // await database.rawUpdate(
    //     'UPDATE Item SET favorite = ?WHERE id = ?', ['$favorite', '$id']);

    firestore
        .collection("databaseProject")
        .doc(id.toString())
        .update({"favorite": favorite});

    getContact();
    getFavorites();
  }

  void deleteItem({required int id}) async {
    // int? count =
    //     await database.rawDelete('DELETE FROM Item WHERE id = ?', ['$id']);
    // assert(count == 1);

    firestore.collection("databaseProject").doc(id.toString()).delete();

    getContact();
    getFavorites();
  }
}
