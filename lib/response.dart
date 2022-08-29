import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users/accept.dart';
import 'package:users/alert.dart';
import 'package:users/styles.dart';
import 'package:users/accept.dart';
//database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:flutter_geofire/flutter_geofire.dart';
// import 'package:users/userRequest.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';

class Waiting extends StatefulWidget {
  static const String idScreen = "testing";
  @override
  _WaitingState createState() => _WaitingState();
}

bool helpResponse = false;
String docId = '';
String docName = '';

class _WaitingState extends State<Waiting> {
  void getDistance() async {
    double userLat = 0.0;
    double userLog = 0.0;

    // if (docId != '') {
    //   FirebaseDatabase.instance
    //       .ref("availableDoctors")
    //       .child(docId)
    //       .get()
    //       .then((value) {
    //     print(value);
    //     print('available doc loc');
    //   });
    // }

//     final db = FirebaseDatabase.instance.reference().child("availableDoctors");
//     db.child(docId).once().then((DataSnapshot snapshot){
//   Map<dynamic, dynamic> values = snapshot.value;
//      values.forEach((key,values) {
//       print(values["Email"]);
//     });
//  });

    //print("fetching realtime location from realtime db");

    // final ref = FirebaseDatabase.instance.ref();
    // final snapshot = await ref.child('availableDoctors/$docId').get();

    //print('avail doc');
    // if (snapshot.exists) {
    //   print(snapshot.value);
    // } else {
    //   //print('No data available.');
    // }
  }

  void getDocInfo() {
    if (docId != '') {
      FirebaseFirestore.instance
          .collection("Doctors")
          .doc(docId)
          .get()
          .then((doc) {
        docName = doc["name"];
      });
      getDistance();
    }
  }

  void removeWaitingDoctors(String doctorId) {
    for (var i = 0; i < availableDoctorsList.length; i++) {
      String otherId = availableDoctorsList[i];
      if (otherId != doctorId) {
        docDoc.doc(otherId).update({"helpRequest": "None"});
      }
    }
  }

  void checkforResponse() async {
    var document = await userDoc.doc(requestId);

    document.get().then((doc) {
      if (doc["status"] == "waiting") {
        //print('waiting');
        setState(() {});
      } else {
        //print("response: ${doc["response"]} ");
        docId = doc["response"];
        //docName = doc["name"];

        getDocInfo();
        removeWaitingDoctors(docId);
        helpResponse = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //return MaterialApp(debugShowCheckedModeBanner: false);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          //drawer: Menubar(),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(248, 32, 42, 68),
            centerTitle: true,
            title: Text('SwiftAid',
                style: GoogleFonts.aladin(
                    fontSize: 30,
                    color: Color.fromARGB(255, 249, 247, 247),
                    fontWeight: FontWeight.w100)),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("UserRequest")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              checkforResponse();
              if (helpResponse) {
                //print('redirecting to accept.dart');
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => accept()));
                return Text('$docName is on the way');
              } else {
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 100, left: 10, right: 10),
                      child: Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Text(
                          "Your request has been notified to nearby doctors! \n\n Meanwhile please try other means of help.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aBeeZee(
                              fontSize: 20,
                              color: Color.fromARGB(248, 26, 52, 117)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: SizedBox(
                        height: 60,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => alert2()));
                          },
                          child: Text(
                            "Cancel Request",
                            style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                color: Color.fromARGB(248, 244, 244, 246)),
                          ),
                          style: logbutton,
                        ),
                      ),
                    ),
                    Image.asset(
                      "images/doctors.jpg",
                      color: const Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate,
                      height: 255,
                      width: 400,
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                );
              }
            },
          )),
    );
  }
}


// Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
//             child: Container(
//               height: 300,
//               alignment: Alignment.center,
//               child: Text(
//                 "Your request has been notified to nearby doctors! \n\n Meanwhile please try other means of help.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.aBeeZee(
//                     fontSize: 20, color: Color.fromARGB(248, 26, 52, 117)),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 7.0),
//             child: SizedBox(
//               height: 60,
//               width: 200,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => alert2()));
//                 },
//                 child: Text(
//                   "Cancel Request",
//                   style: GoogleFonts.aBeeZee(
//                       fontSize: 20, color: Color.fromARGB(248, 244, 244, 246)),
//                 ),
//                 style: logbutton,
//               ),
//             ),
//           ),
//           Image.asset(
//             "images/doctors.jpg",
//             color: const Color.fromRGBO(255, 255, 255, 0.5),
//             colorBlendMode: BlendMode.modulate,
//             height: 255,
//             width: 400,
//             alignment: Alignment.bottomCenter,
//           ),
//         ],
//       ),