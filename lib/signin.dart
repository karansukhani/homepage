import 'package:flutter/material.dart';
import 'package:homepage/homepage.dart';

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Alert"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

void ValidateandSubmit(BuildContext context, String mobile, String pass) {
  if (mobile.isEmpty || pass.isEmpty) {
    showAlertDialog(context, "Please enter E-mail and Password");
  } else if (mobile.toString() == "9033006262" &&
      pass.toString() == "eVital@12") {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homescreen()));
  } else {
    showAlertDialog(context, "Please enter Valid Mobile and Password");
  }
}

class LoginState extends StatefulWidget {

  const LoginState({super.key});

  @override
  State<LoginState> createState() => _LoginStateState();
}

class _LoginStateState extends State<LoginState> {
  var mobilecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Image(
            height: 150,
            image: AssetImage("asset/image/bgremove.png"),
          ),
          Text(
            "Login",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: 8,
          ),
        ]),
        Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_circle_rounded),
                labelText: "Username",
              ),
              controller: mobilecontroller,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              obscureText: true,
              obscuringCharacter: "*",
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.remove_red_eye),
                  labelText: "Password"),
              controller: passcontroller,
            ),
            const SizedBox(
              height: 32,
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      ValidateandSubmit(
                          context,
                          mobilecontroller.text.toString(),
                          passcontroller.text.toString());
                    },
                    child: const Text("Sign In"))),
          ],
        ),
      ]),
    )));
  }
}
