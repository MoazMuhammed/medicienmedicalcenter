import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_cubit.dart';
import 'my_text.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ItemCubit>().getFavorites();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: const Text("Favotites"), backgroundColor: Color(0xFF26C6DA),actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ]),

            body: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    buildItemCategory()
                  ],
                ))));
  }

  Widget buildItemCategory() {
    return Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) => buildItemView(index),
          itemCount: context.read<ItemCubit>().favorites.length,
          scrollDirection: Axis.vertical,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 20,
            );
          },
        )
    );
  }

  Widget buildItemView(index) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("databaseProject")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                      child: Image.network(
                        snapshot.data!.docs[index]['image'],
                      ));
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
        Expanded(
          child: Column(children: [
            Text(
              context.read<ItemCubit>().favorites[index]['title'],maxLines: 1,overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold ),
            ),
          ]),
        ),
        Spacer(),
        Expanded(
          child: Text('Price: '+
            context.read<ItemCubit>().favorites[index]['price'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
        ),
        IconButton(
            onPressed: () {
              context.read<ItemCubit>().updateItem(
                  favorite: 0,
                  id: context.read<ItemCubit>().favorites[index]['id']);
            },
            icon: Icon(Icons.favorite_border))
      ],
    );
  }

  Widget buildAppBar() {
    return Container(color: Colors.blue,
      padding: EdgeInsets.only(left: 10 , right: 10,top: 20 , bottom: 20),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "Favorite",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          ),SizedBox(height: 20,),
          MyText(
            hintText: "Search in favorite ...",
            icon: Icons.search,
            keyboardType: TextInputType.text,
            obscureText: false,
            fillcolor: Colors.white30,
            textInputAction: TextInputAction.search,
          )
        ],
      ),
    );
  }


}
