import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medicienmedicalcenter/auth_controller.dart';
import 'package:medicienmedicalcenter/login_screen.dart';
import 'package:medicienmedicalcenter/my_text.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController forgertpasswordController = TextEditingController();

  @override
  void dispose() {
    forgertpasswordController.dispose();
    super.dispose();
  }

  void forgetPassword() async {
    context.read<Authent>().resetPassword(
        email: forgertpasswordController.text.trim(),
        context: context,);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }


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

  Widget buildTextForm() {
    return Container(
      child: Column(
        children: [

          MyText(
            hintText: "Username",
            icon: Icons.email,
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
            textInputAction: TextInputAction.done,
            controllerr: forgertpasswordController,
          ),

        ],
      ),
    );
  }

  Widget buildSignUp() {
    return Container(
      child: ElevatedButton(
                  onPressed: forgetPassword,
                  child: Text(
                    "Reset password",
                  )));
  }
}
