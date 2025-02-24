import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:woosmap_flutter/woosmap_flutter.dart';

class BleTestPage extends StatefulWidget {
  const BleTestPage({super.key});

  @override
  State<BleTestPage> createState() => _BleTestPageState();
}

class _BleTestPageState extends State<BleTestPage> {
  WoosmapController? _woosmapController;
  LatLng? userLocation;
  Timer? timer;
  int? currentHeading;
  final int bleCount = 1;

  @override
  void dispose() {
    print("Disposing BLE Test Page");
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WoosmapMapViewWidget.create(
        click: (p0) {},
        onRef: (p0) {
          _woosmapController = p0;
        },
        wooskey: "7b2b7ffc-48df-4f1a-9430-6690d81118e0",
        widget: true,
        activate_indoor_product: true,
        indoorRendererConfiguration: IndoorRendererOptions(
          centerMap: true,
          disablePOIInfowindow: true,
          defaultFloor: 0,
          useInfoWindow: false,
          venue: "Amity",
        ),
        indoorWidgetConfiguration: IndoorWidgetOptions(
          units: UnitSystem.metric,
          ui: IndoorWidgetOptionsUI(
              primaryColor: "#318276", secondaryColor: "#004651"),
        ),
        indoor_venue_loaded: (message) {
          onVenueLoaded();
        },
      )),
    );
  }

  void addBearingListener() {
    // Listen to phone's compass changes and rotate the map accordingly
    FlutterCompass.events!.listen((event) {
      if (event.heading == null) return;
      if (userLocation == null) return;
      // Check if the bearing change is too small (abs diff)
      if (currentHeading != null &&
          (currentHeading! - event.heading!.toInt()).abs() <= 2) return;
      currentHeading = event.heading!.toInt();
      _woosmapController!.setUserLocation(userLocation!.lat, userLocation!.lng,
          0, event.heading!.toInt(), true);
      // Rotate map
      _woosmapController!.setHeading(event.heading!.toInt());
    });
  }

  void onVenueLoaded() {
    addBearingListener();
    Timer.periodic(Duration(seconds: 2), (timer) {
      FlutterBluePlus.startScan(
          withServices: [Guid("bf27730d-860a-4e09-889c-2d8b6a9e0fe7")],
          timeout: Duration(seconds: 2));

      var subscription = FlutterBluePlus.onScanResults.listen((results) async {
        ScanResult? fin;
        // Fluttertoast.showToast(msg: "Scanned ${results.length} devices");
        for (ScanResult r in results) {
          if (results.length < bleCount) return;
          if (fin == null || r.rssi.abs() < fin.rssi.abs()) fin = r;
        }

        if (fin == null) return;

        // Fluttertoast.showToast(msg: "Located!!");

        LatLng newUserLocation;

        if (fin.advertisementData.advName.split(" ")[1] == "1") {
          newUserLocation =
              LatLng(lat: 28.624211110729064, lng: 77.18556315921688);
        } else if (fin.advertisementData.advName.split(" ")[1] == "2") {
          newUserLocation =
              LatLng(lat: 28.625757376332814, lng: 77.1867930145221);
        } else {
          newUserLocation =
              LatLng(lat: 28.62631074601461, lng: 77.18595579555301);
        }

        if (userLocation != null &&
            newUserLocation.lat == userLocation!.lat &&
            newUserLocation.lng == userLocation!.lng) return;

        userLocation = newUserLocation;
        setUserLocationAndPan();
      });
    });
  }

  void setUserLocationAndPan() {
    if (userLocation == null) return;
    FirebaseDatabase.instance
        .ref('LocationUpdates')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .push()
        .set({
      'lat': userLocation!.lat,
      'lon': userLocation!.lng,
      'timeInMillis': DateTime.now().millisecondsSinceEpoch
    });
    _woosmapController!
        .setUserLocation(userLocation!.lat, userLocation!.lng, 0, 0, true);
    _woosmapController!.setZoom(18);
    _woosmapController!.setCenter(
        LatLng(lat: userLocation!.lat, lng: userLocation!.lng),
        WoosPadding(bottom: 0, left: 0, right: 0, top: 0));
  }
}
