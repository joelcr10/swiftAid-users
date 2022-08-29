import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users/alert.dart';
import 'package:users/response.dart';
import 'package:users/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class accept extends StatefulWidget {
  @override
  State<accept> createState() => _acceptState();
}

class _acceptState extends State<accept> {
  void initState() {
    super.initState();
    print('inside initstate');
    WidgetsBinding.instance.addPostFrameCallback((_) => locateposition());
  }

  late Position currentposition;
  var geolocator = Geolocator();
  String adress = '';

  void locateposition() async {
    //get the doctors's position instead
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentposition = position;

    LatLng latLngposition = LatLng(position.latitude, position.longitude);
    print(latLngposition);
    List<Placemark> placemark = await placemarkFromCoordinates(
        latLngposition.latitude, latLngposition.longitude);
    print(placemark);
    Placemark place = placemark[0];
    adress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  void dismissRequest() {
    print('accept: $docId');

    try {
      docDoc.doc(docId).update({"helpRequest": "None", "response": "waiting"});

      FirebaseFirestore.instance
          .collection('UserRequest')
          .doc(requestId)
          .delete();

      print('the current request has been terminated');
    } catch (e) {
      print('error $e');
    } finally {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Main()));
      // });
      //Navigator.of(context).pushNamedAndRemoveUntil('/yourscreen', (Route<dynamic> route) => false);
      
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //locateposition();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
                child: Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Text(
                    "Your request has been accepted! \n\n Doctor $docName located at",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                        fontSize: 20, color: Color.fromARGB(248, 26, 52, 117)),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Container(
                    //color: Colors.yellow,
                    height: 25,
                    child: Text(
                      ' ${adress}',
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: SizedBox(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      dismissRequest();
                      print('dismiss request entered');
                      Navigator.push(context,
                           MaterialPageRoute(builder: (context) => Main()));
                    },
                    child: Text(
                      "Dismiss Request",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 20,
                          color: Color.fromARGB(248, 244, 244, 246)),
                    ),
                    //style: logbutton,
                  ),
                ),
              ),
              Image.asset(
                "images/arrive.jpg",
                color: const Color.fromRGBO(255, 255, 255, 0.645),
                colorBlendMode: BlendMode.modulate,
                height: 350,
                width: 400,
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
