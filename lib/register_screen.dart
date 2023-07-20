import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medicienmedicalcenter/auth_controller.dart';
import 'package:medicienmedicalcenter/login_screen.dart';
import 'package:medicienmedicalcenter/my_text.dart';
import 'package:provider/provider.dart';
class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }






  void signUpUser() async {
    await context.read<Authent>().signUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
        phone: phoneController.text.trim(),
        name: nameController.text.trim(), file: File(pickedFile!.path!));



    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));


  }


  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Expanded(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Form(
            key: formkey,
            child: SingleChildScrollView(

              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildWelcomText(),
                    const SizedBox(
                      height: 35,
                    ),
                    buildTextForm(),
                    SizedBox(
                      height: 5,
                    ),
                    buildSignUp(),
                  ]),


            ),
          ),
        ),
      ),
    ));
  }

  Widget buildWelcomText() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [


          Text(
            "Let's Get Started!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),




          Text(
            "Sign up to create your account!",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]);
  }

  Widget buildTextForm() {
    return Column(
      children: [
        ElevatedButton(
            onPressed: selectFile,
            child: const Text(
              "Select Image",
            )),

        SizedBox(
          height: 15,
        ),


        MyText(
          hintText: "Username",
          icon: Icons.person,
          keyboardType: TextInputType.text,
          obscureText: false,
          vvalidator: (value) {
            if (value!.isEmpty) {
              return "Name required";
            }

            return null;
          },
          fillcolor: Colors.white,
          textInputAction: TextInputAction.next,
          controllerr: nameController,
        ),
        SizedBox(
          height: 10,
        ),


        MyText(
          hintText: "Email",
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          vvalidator: (value) {
            if (value!.isEmpty) {
              return "Email required";
            }
            if (!value.contains("@") || !value.contains(".")) {
              return "Email not valid";
            }
            return null;
          },
          fillcolor: Colors.white,
          textInputAction: TextInputAction.next,
          controllerr: emailController,
        ),
        const SizedBox(
          height: 10,
        ),
        MyText(
          hintText: "Password",
          icon: Icons.lock,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscureText,
          vvalidator: (password) {
            if (password!.isEmpty) {
              return "Password required";
              // }else if(password.length !>=6){
              //   return "Password is weak";
            } else
              return null;
          },
          fillcolor: Colors.white,
          suffixIcon: IconButton(
              onPressed: () {
                obscureText = !obscureText;
                setState(() {});
              },
              icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility)),
          textInputAction: TextInputAction.next,
          controllerr: passwordController,
        ),
        SizedBox(
          height: 10,
        ),
        MyText(
          hintText: "Password",
          icon: Icons.lock,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscureText,
          controllerr: passwordConfirmController,
          vvalidator: (value) {
            if (passwordConfirmController.text != passwordController.text) {
              return "Password not match";
            }

            return null;
          },
          fillcolor: Colors.white,
          suffixIcon: IconButton(
              onPressed: () {
                obscureText = !obscureText;
                setState(() {});
              },
              icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility)),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(
          height: 10,
        ),
        MyText(
          hintText: "Phone number",
          icon: Icons.phone,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          obscureText: false,
          vvalidator: (value) {
            if (value!.isEmpty) {
              return "Phone required";
            }

            return null;
          },
          fillcolor: Colors.white,
          textInputAction: TextInputAction.done,
          controllerr: phoneController,
        ),
      ],
    );
  }

  Widget buildSignUp() {
    return Container(

      child: Row(
        children: [
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      return signUpUser();
                    } else {
                      return null;
                    }
                  },
                  child: Text(
                    "Sign up",
                  ))),
          const SizedBox(
            width: 6,
          ),
        ],
      ),


    );
  }
}
