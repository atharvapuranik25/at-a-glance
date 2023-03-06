import 'package:at_a_glance/home_page.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class TitlePage extends StatefulWidget {
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Starting_page_1.png"),
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
                                  Icons.phone,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "\t\t\tSignUp with Phone",
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
                          const Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '+91',
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
                                  Icons.mail,
                                  size: 30,
                                  color: Colors.orange,
                                ),
                                Text(
                                  "\t\t\tSignUp with email",
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
                          const Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'johndoe@gmail.com',
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
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const HomePage(),
                                    ),
                                  );
                                },
                                child: const Text("SignUp"),
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
                              "Already have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
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
                              "LogIn",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
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
}
