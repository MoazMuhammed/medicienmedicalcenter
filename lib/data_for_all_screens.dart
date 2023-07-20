import 'package:flutter/material.dart';

class DataForAllScreen extends StatelessWidget {
   DataForAllScreen(this.products,{Key? key}) : super(key: key);
   Map products;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF26C6DA),Colors.blue])),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.bottomCenter,
              children: [
            Image.network(products['image'],),
                Container(height: 50,padding: EdgeInsets.all(10),margin: EdgeInsets.all(20),decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.indigo,) ,child: Row(
                  children: [
                    Text(products['title'],style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),Spacer(),
                    Text(products['price'],style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),SizedBox(width: 3,),
                    Text("EGP",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
                  ],
                ),

                )

              ],
            ),SizedBox(height: 290,)   ,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
  children: [
           SizedBox(
      width: 250,
      height: 40,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            primary: Colors.white,
            onPrimary: Colors.blue,
          ),
          onPressed: () {

          },
          child: Text(
            "Add to cart",
          )),
    ),
    IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart),color: Colors.indigo,)

  ],
)


          ]
        ),
      )


    ));
  }
}
