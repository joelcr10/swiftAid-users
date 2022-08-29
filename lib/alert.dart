import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users/cancel.dart';
import 'package:users/main.dart';
import 'package:users/response.dart';
import 'package:geolocator/geolocator.dart';

//backend imports
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:users/userRequest.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:users/nearbyAvailableDoctors.dart';
//import 'package:users/nearbyAvailableDoctors.dart';
import 'package:users/geoFireAssistant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final userDoc = FirebaseFirestore.instance.collection("UserRequest");
final docDoc = FirebaseFirestore.instance.collection("Doctors");
String requestId = '';
//String docId = '';

late Position currentPosition;
List<dynamic> nearbyDoctorsList = [];
List<dynamic> availableDoctorsList = [];

// ignore: must_be_immutable
class alert1 extends StatelessWidget {
  String requestStatus = "waiting";
  var av;
  //late Position currentposition;
  var geolocator = Geolocator();

  void sendHelpRequest() async {
    //docId = "G9yoYiAB5RXRO3ziETGwhiVrRT53";

    for (var i = 0; i < nearbyDoctorsList.length; i++) {
      String doctorId = nearbyDoctorsList[i];
      FirebaseFirestore.instance
          .collection("Doctors")
          .doc(doctorId)
          .get()
          .then((docs) => {
                print('the req id(helpRequest) ${requestId}'),
                if (docs["helpRequest"] == "None")
                  {
                    availableDoctorsList.add(doctorId),
                    print('updating the help request'),
                    FirebaseFirestore.instance
                        .collection('Doctors')
                        .doc(doctorId)
                        .update({"helpRequest": requestId})
                  }
                else
                  {print('no updation')}
              });
    }
  }

  void locateposition() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if (servicestatus) {
      print("GPS service is enabled");
    } else {
      print("GPS service is disabled.");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    GeoFirePoint geoFirePoint =
        GeoFirePoint(position.latitude, position.longitude);
    var docLat = position.latitude.toString();

    var docLog = position.longitude.toString();

    userDoc.doc(requestId).set({
      'Location': geoFirePoint.data,
      'position': [docLat, docLog]
    }, SetOptions(merge: true)).then((_) {
      print('added ${geoFirePoint.hash} successfully');

      //sendHelpRequest();
    });

    print(position.latitude);
    print(position.longitude);

    initGeoFireListener();
    //sendHelpRequest();
  }

  //creates a request inside the firestore with requestId, date, status
  Future createRequest() async {


    //check for internet connection to send request
    final ConnectivityResult result = await Connectivity().checkConnectivity();
 
    if (result == ConnectivityResult.wifi) {
      print('Connected to a Wi-Fi network');
    } else if (result == ConnectivityResult.mobile) {
      print('Connected to a mobile network');
    } else {
      print('Not connected to any network');
    }
  
    final requestDoc = userDoc.doc(); //creating a new helpRequest document with auto Id
    print(requestDoc.id);
    requestId = requestDoc.id; //initializing the global requestId
    // final user = UserRequest(
    //     id: requestDoc.id, requestDate: DateTime.now(), status: requestStatus);

    final user =
        UserRequest(id: requestId,requestDate: DateTime.now(), status: requestStatus); //userRequest

    final json = user.toJson(); //converting the user data to json format
    await requestDoc.set(json); //pushing the json data to the database
    print('pushed data to database');
    locateposition();
  }

  @override
  Widget build(BuildContext context) {
    av() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Waiting()));
    }

    return Container(
      color: Color.fromARGB(250, 149, 147, 147),
      child: AlertDialog(
          backgroundColor: Color.fromARGB(248, 32, 42, 68),
          title: Text(
            'Are you sure?',
            style: GoogleFonts.aBeeZee(
                color: Color.fromARGB(255, 253, 252, 252), fontSize: 20),
          ),
          content: Text(
            'Do you want to send a request?',
            style: GoogleFonts.aBeeZee(
                color: Color.fromARGB(255, 253, 252, 252), fontSize: 17),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => User())),
                child: Text("No",
                    style: GoogleFonts.aBeeZee(
                        color: Color.fromARGB(255, 253, 252, 252),
                        fontSize: 15))),
            TextButton(
                onPressed: () => {
                      print("Before Request"),
                      //locateposition(),
                      createRequest(),
                      print("After Request"),
                      av()
                    },
                child: Text("Yes",
                    style: GoogleFonts.aBeeZee(
                        color: Color.fromARGB(255, 253, 252, 252),
                        fontSize: 15)))
          ]),
    );
  }

  void initGeoFireListener() {
    Geofire.initialize("availableDoctors");
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude,
            2) //within 2km of user location
        ?.listen((map) {
      print('this is the map');
      //print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDoctors nearbyAvailableDoctors =
                NearbyAvailableDoctors();
            nearbyAvailableDoctors.key = map['key'];
            nearbyAvailableDoctors.latitude = map['latitude'];
            nearbyAvailableDoctors.longitude = map['longitude'];
            GeoFireAssistant.nearbyAvailableDoctorsList
                .add(nearbyAvailableDoctors);

            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDoctorFromList(map['key']);
            //updateAvailableDoctorsOnMap();

            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDoctors nearbyAvailableDoctors =
                NearbyAvailableDoctors();
            nearbyAvailableDoctors.key = map['key'];
            nearbyAvailableDoctors.latitude = map['latitude'];
            nearbyAvailableDoctors.longitude = map['longitude'];
            GeoFireAssistant.updateDoctorNearbyLocation(nearbyAvailableDoctors);
            //updateAvailableDoctorsOnMap();

            break;

          case Geofire.onGeoQueryReady:
            //updateAvailableDoctorsOnMap();

            break;
        }
      }
      nearbyDoctorsList = map["result"];
      print(nearbyDoctorsList);
      sendHelpRequest();

      //setState(() {});
    });
    //print(loc);
    //sendHelpRequest();
  }

  // void updateAvailableDoctorsOnMap() {
  //   setState(() {
  //     markersSet.clear();
  //   });

  //   Set<Marker> tMakers = Set<Marker>();
  //   for (NearbyAvailableDoctors doctors
  //       in GeoFireAssistant.nearbyAvailableDoctorsList) {
  //     LatLng doctorAvailablePosition =
  //         LatLng(doctors.latitude!, doctors.longitude!);
  //     Marker marker = Marker(
  //       markerId: MarkerId('doctor${doctors.key}'),
  //       position: doctorAvailablePosition,
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),

  //       ///rotation: 10,
  //       rotation: Random().nextInt(360).toDouble(),
  //     );

  //     tMakers.add(marker);
  //   }
  //   setState(() {
  //     markersSet = tMakers;
  //   });
  // }
}

class alert2 extends StatelessWidget {
  void cancelRequest() {
    print('the ref id:' + requestId);
    if (requestId == '') {
      print('nothing to delete');
    } else {
      FirebaseFirestore.instance
          .collection('UserRequest')
          .doc(requestId)
          .delete();
      print('deleted the document');

      for (var i = 0; i < availableDoctorsList.length; i++) {
        String doctorId = availableDoctorsList[i];
        print(doctorId);
        docDoc.doc(doctorId).update({"helpRequest": "None"});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(250, 149, 147, 147),
      child: AlertDialog(
          backgroundColor: Color.fromARGB(248, 32, 42, 68),
          title: Text(
            'Are you sure?',
            style: GoogleFonts.aBeeZee(
                color: Color.fromARGB(255, 253, 252, 252), fontSize: 20),
          ),
          content: Text(
            'Do you want to cancel the request?',
            style: GoogleFonts.aBeeZee(
                color: Color.fromARGB(255, 253, 252, 252), fontSize: 17),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Waiting())),
                child: Text(
                  "No",
                  style: GoogleFonts.aBeeZee(
                      color: Color.fromARGB(255, 253, 252, 252), fontSize: 15),
                )),
            TextButton(
                onPressed: () {
                  cancelRequest();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => cancel()));
                },
                child: Text(
                  "Yes",
                  style: GoogleFonts.aBeeZee(
                      color: Color.fromARGB(255, 253, 252, 252), fontSize: 15),
                ))
          ]),
    );
  }
}
