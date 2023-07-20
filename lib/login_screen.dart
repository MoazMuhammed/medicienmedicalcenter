import 'package:flutter/material.dart';
import 'package:medicienmedicalcenter/auth_controller.dart';
import 'package:medicienmedicalcenter/forget_password_screen.dart';
import 'package:medicienmedicalcenter/my_text.dart';
import 'package:medicienmedicalcenter/register_screen.dart';
import 'package:provider/provider.dart';
TextEditingController emailController = TextEditingController();
TextEditingController passworfController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();



  void loginUser() async {
    context.read<Authent>().loginWithEmail(
        email: emailController.text.trim(),
        password: passworfController.text.trim(),
        context: context);
  }

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Expanded(
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Form(
            key: formkey,
            child: Column(
              children: [
                // buildImageLogin(),
                const SizedBox(
                  height: 3,
                ),
                const SizedBox(
                  height: 3,
                ),
                buildDescriptionText(),
              ],
            ),
          ),
        ),
      ),
    ));
  }



  Widget buildDescriptionText() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("lib/images/loginImageScreen.jpg"),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Welcome back!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        Text(
          "Login in to your existant account of Medicien ",
          style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500]),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
        MyText(
            hintText: "Email",
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            vvalidator: (valuee) {
              if (valuee!.isEmpty) {
                return "Email required";
              }
              if (!valuee.contains("@") || !valuee.contains(".")) {
                return "Email not valid";
              }
              return null;
            },
            fillcolor: Colors.white,
            textInputAction: TextInputAction.next,
            controllerr: emailController),
        const SizedBox(
          height: 15,
        ),
        MyText(
            hintText: "Password",
            icon: Icons.lock,
            keyboardType: TextInputType.visiblePassword,
            obscureText: obscureText,
            vvalidator: (value) {
              if (value!.isEmpty) {
                return "Password required";
              }

              return null;
            },
            fillcolor: Colors.white,
            suffixIcon: IconButton(
                onPressed: () {
                  obscureText = !obscureText;
                  setState(() {});
                },
                icon: Icon(obscureText
                    ? Icons.visibility_off
                    : Icons.visibility)),
            textInputAction: TextInputAction.done,
            controllerr: passworfController),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 400,
          height: 40,
          child: ElevatedButton(
          onPressed: () {
            if (formkey.currentState!.validate()) {
              return loginUser();
            } else {
              return;
            }
          },
          child: const Text(
            "Sign in",
          )),
        ),
        const SizedBox(
          height: 2,
        ),
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgetPassword(),
                ));
          },
          child: const Text(
            "                                                          Forget password",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          )),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold)),
            TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ));
            },
            child: const Text(
              "Sign up",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            )),
          ],
        )
          ])
        ]),
      ),
    );
  }
}
