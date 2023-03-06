import 'package:at_a_glance/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Starting_page_2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Flexible(
                    //title
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: "Indore",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "\nAt a Glance",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    //login/signup
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.mail,
                                  size: 30,
                                  color: Colors.orange,
                                ),
                                Text(
                                  "\t\t\tLogin with Email",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Email Address',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Flexible(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.password,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "\t\t\tEnter Password",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: TextField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () async {
                                  logIn();
                                },
                                child: const Text("Login"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                onPressed: () {},
                                child: const Text("SignUp with Google"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, "signup");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.blue,
                                elevation: 0,
                              ),
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    if (FirebaseAuth.instance.currentUser != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "home");
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "login");
    }
  }
}
