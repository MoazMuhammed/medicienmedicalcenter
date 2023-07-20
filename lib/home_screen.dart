import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicienmedicalcenter/auth_controller.dart';
import 'package:medicienmedicalcenter/category_models.dart';
import 'package:medicienmedicalcenter/catigory_cubit.dart';
import 'package:medicienmedicalcenter/data_for_all_screens.dart';
import 'package:medicienmedicalcenter/item_cubit.dart';
import 'package:medicienmedicalcenter/login_screen.dart';
import 'package:medicienmedicalcenter/my_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_statement.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences? prefs;

  Map<String, dynamic> data = {
    "name": "",
    "image": "",
    "email": "",
    "phone": "",
  };

  @override
  void initState() {
    super.initState();
    context.read<ItemCubit>().createDatabase();

    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      data = value.data()!;

      prefs = await SharedPreferences.getInstance();
      await prefs?.setBool('admin', value.data()!.containsKey("admin"));

      setState(() {});
    });
  }

  void signOut() async {
    context.read<Authent>().signOut(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  int number = 0;

  bool isBottomSheetExpand = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'ProfileName';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool admin = prefs?.getBool('admin') ?? false;

    print('ADMIN $admin');

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      floatingActionButton: Visibility(
          visible: admin,
          child: FloatingActionButton(
            onPressed: () {
              if (isBottomSheetExpand) {
                if (formkey.currentState!.validate()) {
                  Navigator.pop(context);
                  isBottomSheetExpand = false;
                }
              } else {
                buildBottomSheet();
                isBottomSheetExpand = true;
              }
              setState(() {});
            },
            child: Icon(isBottomSheetExpand ? Icons.done : Icons.add),
          )),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Color(0xFF26C6DA), Colors.white70])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                child: Image.network(data['image']),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Name: ' + data['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.black45)),
              Text('Email: ' + data['email'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black45)),
              Text('Phone: ' + data['phone'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black45)),
            ],
          ),
        ),
      ),
      appBar: AppBar(title: const Text("Home"), backgroundColor: Color(0xFF26C6DA),actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: signOut,
          icon: const Icon(Icons.exit_to_app),
        ),
      ]),
      body: Container(
        color: Colors.white24,
        width: double.infinity,
        child: Column(
          children: [buildCategoryModel(), buildItemCategory()],
        ),
      ),
    ));
  }

  Widget buildItemCategory() {
    return Expanded(
        child: BlocBuilder<ItemCubit, ItemStates>(
      buildWhen: (previous, current) => current is GetItemStates,
      builder: (context, state) {
        print('Contact State => $state');
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.99),
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection("databaseProject")
                      .get()
                      .then((value) {
                    List<Map<dynamic, dynamic>> data = [];
                    for (var doc in value.docs) {
                      data.add(doc.data());
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataForAllScreen(data[index]),
                        ));
                  });
                },
                child: buildItemView(index));
          },
          itemCount: context.read<ItemCubit>().items.length,
          scrollDirection: Axis.vertical,
        );
      },
    ));
  }
  Widget buildCategoryModel() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("category").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                height: 80,
                margin: EdgeInsets.all(10),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return categoryItem(index, data);
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }

      },
    );
  }
  Widget buildCategoryList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("category").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                height: 80,
                margin: EdgeInsets.all(10),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return categoryItem(index, data);
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }

      },
    );
  }
  Widget categoryItem(index, data) {
    return InkWell(
      onTap: () {
        String category = "";
        switch (index) {
          case 0:
            category = "child";
            break;
            case 1:
            category = "corona";
            break;
            case 2:
            category = "firstaid";
            break;  case 3:
            category = "healthandbeauty";
            break;  case 4:
            category = "medicaltool";
            break;  case 5:
            category = "mencare";
            break;  case 6:
            category = "pain";
            break;  case 7:
            category = "teeth";
            break;


        }
        FirebaseFirestore.instance.collection('category')
            .doc(category)
            .collection(category)
            .get()
            .then((value) {
          List<Map> docs =[];
          for (var doc in value.docs) {
            docs.add(doc.data());
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryModels(category,docs)));
        });

      },
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(data['image']),
                radius: 30,
              ),
              Text(data['title']),
            ],
          ),
        ],
      ),
    );
  }




  // Widget buildCategory(index) {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(color: Color(0xFF00BCD4), borderRadius: BorderRadius.circular(20),shape: BoxShape.rectangle),
  //     child: Column(children: [
  //    Image.asset(category[index].image, height: 70, width: 55),
  //       Text(category[index].name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
  //     ]),
  //   );
  // }

  Widget buildItemView(index) {
    final bool admin = prefs?.getBool('admin') ?? false;
    print('ADMIN $admin');
    return Card(
        margin: const EdgeInsets.all(5),
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: const BorderSide(
                width: 1, color: Color(0xFF01579B), style: BorderStyle.solid)),
        borderOnForeground: true,
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 10.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("databaseProject")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: Image.network(
                            snapshot.data!.docs[index]['image'],
                          ));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Text(
                context.read<ItemCubit>().items[index]['title'],
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Price: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),overflow: TextOverflow.ellipsis,maxLines: 1),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  context.read<ItemCubit>().items[index]['price'],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black38),
                ),
              ]),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      context.read<ItemCubit>().updateItem(
                          favorite: context.read<ItemCubit>().items[index]
                                      ['favorite'] ==
                                  0
                              ? 1
                              : 0,
                          id: context.read<ItemCubit>().items[index]['id']);
                    },
                    icon: Icon(
                      context.read<ItemCubit>().items[index]['favorite'] == 0
                          ? Icons.favorite_border
                          : Icons.favorite_outlined,
                      color: Color(0xFF01579B),
                    )),
                Visibility(
                  visible: admin,
                  child: IconButton(
                      onPressed: () {
                        context.read<ItemCubit>().deleteItem(
                            id: context.read<ItemCubit>().items[index]['id']);
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.brown,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool obscureText = true;

  void buildBottomSheet() {
    scaffoldKey.currentState!
        .showBottomSheet((context) {
          return Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF00BCD4),Color(0xFF26C6DA)])),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (pickedFile != null)
                      Expanded(
                          child: CircleAvatar(
                              radius: 50,
                              child: Image.file(
                                File(pickedFile!.path!),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ))),
                    const SizedBox(
                      height: 10,
                    ),
                    MyText(
                      hintText: "Name of object",
                      icon: Icons.drive_file_rename_outline,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      vvalidator: (value) {
                        obscureText = !obscureText;
                        setState(() {});
                        if (value!.isEmpty) {
                          return "Enter Name";
                        }

                        return null;
                      },
                      fillcolor: Colors.white,
                      textInputAction: TextInputAction.done,
                      controllerr: titleController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    MyText(
                      hintText: "Price of object",
                      icon: Icons.drive_file_rename_outline,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      vvalidator: (value) {
                        if (value!.isEmpty) {
                          obscureText = !obscureText;
                          setState(() {});
                          return "Enter Price";
                        }

                        return null;
                      },
                      fillcolor: Colors.white,
                      textInputAction: TextInputAction.done,
                      controllerr: priceController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      ElevatedButton(
                          onPressed: () {
                            String title = titleController.text;
                            String price = priceController.text;

                            titleController.clear();
                            priceController.clear();

                            context.read<ItemCubit>().insertContact(
                                  title: title,
                                  price: price,
                                  file: File(pickedFile!.path!),
                                  image: '',
                                );
                          },
                          child: const Text(
                            "Add all",
                          )),
                    ]),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().insertmencare(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "Men care",
                            )),
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().inserthealthandbeauty(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "Health and beauty",
                            )),
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().insertfirstaid(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "First aid",
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().insertchild(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "Children",
                            )),
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().insertteeth(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "Teeth",
                            )),
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().insertcorona(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "Corona",
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().insertmedicaltool(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "Medical tools",
                            )),
                        ElevatedButton(
                            onPressed: () {
                              String title = titleController.text;
                              String price = priceController.text;

                              titleController.clear();
                              priceController.clear();

                              context.read<ItemCubit>().insertContact(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );

                              context.read<CatigoryCubit>().insertpain(
                                    title: title,
                                    price: price,
                                    file: File(pickedFile!.path!),
                                    image: '',
                                  );
                            },
                            child: const Text(
                              "Pain",
                            )),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: selectFile,
                        child: const Text(
                          "Select Image",
                        )),
                    ElevatedButton(
                        onPressed: uploadFile,
                        child: const Text(
                          "Upload Image",
                        )),
                  ],
                ),
              ),
            ),
          );
        })
        .closed
        .then((value) {
          isBottomSheetExpand = false;
          setState(() {});
        });
  }
}

class Category {
  String image;
  String name;

  Category(this.image, this.name);
}

class ItemCategory {
  String image;
  String name;
  String price;

  ItemCategory({required this.image, required this.name, required this.price});
}
