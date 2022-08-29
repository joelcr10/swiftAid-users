import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menubar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text("SwiftAid",
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.alegreya(
                        fontSize: 50,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 251, 252, 253))),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(248, 32, 42, 68),
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.people, color: Color.fromARGB(255, 6, 43, 74)),
              title: Text('About us'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}
