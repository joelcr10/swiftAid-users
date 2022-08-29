
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

// import 'package:geohash/geohash.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class UserRequest {
  late String id;
  late DateTime requestDate;
  late String status;

  UserRequest({
    this.id = '',
    required this.requestDate,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        "requestDate": requestDate,
        "status": status,
      };
}