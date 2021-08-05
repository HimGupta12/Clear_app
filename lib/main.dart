import 'package:clear_flutterapp/Screens/intoduction_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(WelocomeScreen());
}


class WelocomeScreen extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return  MaterialApp(
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: WelcomeScreen(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
         return
           MaterialApp(
             theme: ThemeData(
               // This is the theme of your application.
               //
               // Try running your application with "flutter run". You'll see the
               // application has a blue toolbar. Then, without quitting the app, try
               // changing the primarySwatch below to Colors.green and then invoke
               // "hot reload" (press "r" in the console where you ran "flutter run",
               // or simply save your changes to "hot reload" in a Flutter IDE).
               // Notice that the counter didn't reset back to zero; the application
               // is not restarted.
               primarySwatch: Colors.blue,
             ),
             home: Scaffold(
               backgroundColor: Colors.grey,
               body: Text('Conncetion Failed'),
             ),
           );
      },
    );
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     theme: ThemeData(
  //       // This is the theme of your application.
  //       //
  //       // Try running your application with "flutter run". You'll see the
  //       // application has a blue toolbar. Then, without quitting the app, try
  //       // changing the primarySwatch below to Colors.green and then invoke
  //       // "hot reload" (press "r" in the console where you ran "flutter run",
  //       // or simply save your changes to "hot reload" in a Flutter IDE).
  //       // Notice that the counter didn't reset back to zero; the application
  //       // is not restarted.
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: WelcomeScreen(),
  //   );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void nextPage(BuildContext context) {
    print('next Page called');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SliderBaseClass(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onTap: () {
            nextPage(context);
          },
          onHorizontalDragUpdate: (details) {
            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
            int sensitivity = 8;
            if(details.delta.dx < -sensitivity){
              //Left Swipe
              nextPage(context);
            }
          },
          child: SizedBox.expand(
            child: Card (
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle (
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w300,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Clear',
                          style: TextStyle (
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Tap or swipe ',
                      style: TextStyle (
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'to begin.',
                          style: TextStyle (
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],

                    ),
                  ),
                  //SizedBox.expand(
                 // ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
