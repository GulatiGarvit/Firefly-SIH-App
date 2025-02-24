import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:woosmap_flutter/woosmap_flutter.dart';
import 'package:http/http.dart' as http;

class NavigationTestPage extends StatefulWidget {
  const NavigationTestPage({super.key});

  @override
  State<NavigationTestPage> createState() => _NavigationTestPageState();
}

class _NavigationTestPageState extends State<NavigationTestPage> {
  WoosmapController? _woosmapController;
  LatLng currentUserLocation =
      LatLng(lat: 28.62426205459619, lng: 77.18564641038687);
  int currentHeading = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WoosmapMapViewWidget.create(
        click: (p0) {},
        onRef: (p0) {
          _woosmapController = p0;
        },
        wooskey: "a21f4a5d-595b-439c-9628-a62949aee455",
        widget: true,
        activate_indoor_product: true,
        indoorRendererConfiguration: IndoorRendererOptions(
          centerMap: true,
          disablePOIInfowindow: true,
          defaultFloor: 0,
          useInfoWindow: false,
          venue: "ishuven",
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
    FlutterCompass.events!.listen((event) {
      if (event.heading != null) {
        if ((currentHeading - event.heading!.toInt()).abs() <= 1) return;
        currentHeading = event.heading!.toInt();
        _woosmapController!.setUserLocation(currentUserLocation.lat,
            currentUserLocation.lng, 0, event.heading!.toInt(), false);
      }
    });
  }

  void onVenueLoaded() {
    addBearingListener();
    // Make a polyline from the user's location to the destination
    loadNav();
    _woosmapController!.setUserLocation(
        currentUserLocation.lat, currentUserLocation.lng, 0, 0, true);
    _woosmapController!.setZoom(18);

    _woosmapController!.setCenter(
        LatLng(lat: currentUserLocation.lat, lng: currentUserLocation.lng),
        WoosPadding(bottom: 0, left: 0, right: 0, top: 0));
  }

  void loadNav() async {
    final response = await http
        .get(Uri.parse("https://b70a-104-28-222-179.ngrok-free.app/test"));

    dynamic path = jsonDecode(response.body)['path'];
    for (var row in path) {
      MarkerOptions options = MarkerOptions(
        position: LatLng(lat: row[1], lng: row[0]),
        icon: WoosIcon(
            url:
                "https://www.pinclipart.com/picdir/big/28-288762_all-photo-png-clipart-google-map-round-marker.png",
            scaledSize: WoosSize(height: 11, width: 11)),
      );
      var marker = Marker.create(options, _woosmapController!);
      marker.add();
    }
  }
}
