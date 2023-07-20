import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicienmedicalcenter/auth_controller.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void signOut() async {
    context.read<Authent>().signOut(context);
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  String? name = "";
  String? email = "";
  String? phone = "";

Future _getDataFirebase()async {
  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((sanpshot) async{
    if(sanpshot.exists){

setState(() {
  name = sanpshot.data()!["name"];
});
    }
  });
}


  @override
  void initState() {
    super.initState();
    _getDataFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        child: Column(
          children: [
            // StreamBuilder<QuerySnapshot>(
            //     stream: firestore.collection("Users").where("email").snapshots(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: snapshot.data!.docs.length,
            //             itemBuilder: (context, i) {
            //               QueryDocumentSnapshot x = snapshot.data!.docs[i];
            //               return ListTile(
            //                 title: Text(x["name"]),
            //                 subtitle:Text(x["email"]),
            //               );
            //             });
            //       }else{
            //         return Center(child: CircularProgressIndicator(),);
            //       }
            //     }),
Text("Name:" + name!),

            ElevatedButton(
                onPressed: signOut,
                child: Text(
                  "Sign out",
                )),
            ElevatedButton(
                onPressed: () {
                  context.read<Authent>().deleteAccount(context);
                  setState(() {});
                },
                child: Text(
                  "Delete account",
                )),
          ],
        ),
      ),
    );
  }
}
