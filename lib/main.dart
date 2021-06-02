import 'package:flutter/material.dart';
import 'package:project/App_store.dart';
import 'package:project/home_icon_buttoms.dart';
import 'package:project/screens/a*.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(VxState(
    store: AppStore(),
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyHomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        AStar.routname: (context) => AStar(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF363567),
      body: ListView(
        children: [
          Stack(
            children: [
              Transform.rotate(
                origin: Offset(30, -60),
                angle: 2.4,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 75,
                    top: 40,
                  ),
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      colors: [Color(0xffFD8BAB), Color(0xFFFD44C4)],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Glassify Transaction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Glassify this transaction into a \n pticular catigory ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: GridView.count(
                            crossAxisCount: 2,
                            children: <Widget>[
                              CatigoryW(
                                image: 'images/Icon1.png',
                                text: 'General',
                                color: Color(0xFF47B4FF),
                                routname: AStar.routname,
                              ),
                              CatigoryW(
                                image: 'images/Icon2.png',
                                text: 'Transport',
                                color: Color(0xFFA885FF),
                              ),
                              CatigoryW(
                                image: 'images/Icon3.png',
                                text: 'Shopping',
                                color: Color(0xFFFD47DF),
                              ),
                              CatigoryW(
                                image: 'images/Icon4.png',
                                text: 'Bills',
                                color: Color(0xFFFD8C44),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
