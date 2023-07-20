
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModels extends StatefulWidget {
  CategoryModels(this.category, this.docs, {Key? key,}) : super(key: key);
  List<Map<dynamic, dynamic>> docs;
  final category;

  @override
  State<CategoryModels> createState() => _CategoryModelsState();
}

class _CategoryModelsState extends State<CategoryModels> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

          body: Column(
            children: [
              buildCustomSearch(),

              Expanded(
                child: GridView.builder(

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),

                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: CircleAvatar(

                                backgroundImage: NetworkImage(
                                    "${widget.docs[index]['image']}"),

                                radius: 45,
                              ),
                            ),
                            Text('${widget.docs[index]['title']}'),


                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: widget.docs.length,
                ),
              ),
            ],
          )

      ),
    );
  }

  Widget buildCustomSearch() {
    return Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0), color: Color(0xFF26C6DA)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),


                  Center(child: Text(widget.category,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),)),
                  Row(
                    children: [

                      IconButton(onPressed: () {

                      }, icon: Icon(Icons.search,color: Colors.white,)),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}