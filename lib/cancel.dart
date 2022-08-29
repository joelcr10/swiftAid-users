import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users/main.dart';
import 'dart:async';

class cancel extends StatefulWidget {
  @override
  _cancelState createState() => _cancelState();
}

class _cancelState extends State<cancel> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => User())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(248, 32, 42, 68),
          centerTitle: true,
          title: Text('SwiftAid',
              style: GoogleFonts.aladin(
                  fontSize: 30,
                  color: Color.fromARGB(255, 249, 247, 247),
                  fontWeight: FontWeight.w100)),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
            child: Container(
              height: 420,
              alignment: Alignment.center,
              child: Text(
                '\n\n Your request has been cancelled \n Redirecting to Home page...',
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                    color: Color.fromARGB(248, 32, 42, 68), fontSize: 20),
              ),
            ),
          ),
          Image.asset(
            "images/arrive.jpg",
            color: const Color.fromRGBO(255, 255, 255, 0.5),
            colorBlendMode: BlendMode.modulate,
            height: 255,
            width: 400,
            alignment: Alignment.bottomCenter,
          ),
        ]),
      ),
    );
  }
}
