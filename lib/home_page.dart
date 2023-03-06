import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.start,
          text: const TextSpan(
              text: "Indore",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "\nAt A Glance",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                    ))
              ]),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chat_rounded,
                color: Colors.black,
              ))
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (currentIndex == 1) {
              //Home
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFf1f1f1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF252525),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2196f3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffa800),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      flex: 5,
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: Color(0xFFf1f1f1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (currentIndex == 0) {
              //Services
              return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: const [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'What servies are you looking for',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      
                    ],
                  ));
            } else if (currentIndex == 2) {
              //Search
              return Container();
            } else if (currentIndex == 3) {
              //Profile
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: 'Services',
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
