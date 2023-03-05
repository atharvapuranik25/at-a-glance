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
        child: Center(
          child: Column(
            children: [
              Container(
                //figure out padding later
                padding: const EdgeInsets.all(90),
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
                            text: "\nAt A Glance",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ))
                      ]),
                ),
              ),
              Container(
                //fix the contant size to make it responsive
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                height: 550,
                width: 350,
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.phone,
                          size: 30,
                          color: Colors.blue,
                        ),
                        Text(
                          "SignUp with phone",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '+91',
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          size: 30,
                          color: Colors.blue,
                        ),
                        Text(
                          "SignUp with Email",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'johndoe@gmail.com',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 15),
                      ),
                      child: const Text("SignUp"),
                    ),
                    const Text("OR"),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      ),
                      child: const Text("SignUp with Google"),
                    ),
                    const Text("Already Have an Account?"),
                    const Text("LogIn"),
                  ],
                ),
              ),
              Container(
                //change this later
                height: 100,
                child: const Center(
                  child: Text(
                    "Read Privacy Policy",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
