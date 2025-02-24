import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firefly_user/apis/navigation.dart';
import 'package:firefly_user/models/node.dart';
import 'package:firefly_user/providers/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:woosmap_flutter/woosmap_flutter.dart';

class NavigationPage extends StatefulWidget {
  final int incidentId;

  const NavigationPage(this.incidentId, {super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  StreamSubscription? s1, s2, s3;
  String? distance;
  String? time;
  String? type;
  WoosmapController? _controller;
  double currentLat = 0;
  double currentLng = 0;
  int currentNode = -1;
  List<int> nodes = [];
  bool uploadedOnce = false;
  List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22))),
              height: MediaQuery.of(context).size.height / 8,
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_circle_up,
                    size: MediaQuery.of(context).size.width / 6,
                    color: Colors.white,
                  ),
                  // Image.asset(
                  //   "assets/images/up_arrow.png",
                  //   width: MediaQuery.of(context).size.width / 6,
                  // ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(distance ?? "Calculating...",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text(time ?? "Please wait",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  WoosmapMapViewWidget.create(
                    wooskey: "7b2b7ffc-48df-4f1a-9430-6690d81118e0",
                    widget: true,
                    activate_indoor_product: true,
                    indoorRendererConfiguration: IndoorRendererOptions(
                        centerMap: true, defaultFloor: 0, venue: "Amity"),
                    indoorWidgetConfiguration: IndoorWidgetOptions(
                      units: UnitSystem.metric,
                      ui: IndoorWidgetOptionsUI(
                          primaryColor: "#318276", secondaryColor: "#004651"),
                    ),
                    onRef: (p0) async {
                      _controller = p0;
                      // reloadMenu();
                    },
                    indoor_venue_loaded: (message) {
                      // setState(() {
                      //   isLoading = false;
                      // });
                      onVenueLoaded();
                    },
                    indoor_feature_selected: (message) {},
                    indoor_level_changed: (message) {},
                    indoor_user_location: (message) {},
                    indoor_directions: (message) {
                      _controller?.setDirections(message);
                    },
                    indoor_highlight_step: (message) {},
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 8.0,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 4,
                              width: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Image.asset(
                                            "assets/images/cancel.png",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Routing you to $type",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Safe throughout your journey",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, right: 12),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          // TODO
                          // _launchCaller();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NavigationPage(widget.incidentId)));
                        },
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.green)),
                        backgroundColor: Colors.white,
                        child: Icon(Icons.phone, color: Colors.green),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20 + 100, right: 12),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          switchMode();
                        },
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.red)),
                        backgroundColor: Colors.red,
                        child:
                            Icon(Icons.medical_services, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isExit = true;

  void switchMode() {
    requestRouting(widget.incidentId, FirebaseAuth.instance.currentUser!.uid,
        mode: isExit ? 'medkit' : 'exit');
    isExit = !isExit;
  }

  bool located = false;

  void onVenueLoaded() {
    startBleService();
    startFireService();
    // startListeningToNav();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    s1?.cancel();
    s2?.cancel();
    s3?.cancel();
    timer?.cancel();
  }

  void startBleService() async {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      FlutterBluePlus.startScan(
          withServices: [Guid("bf27730d-860a-4e09-889c-2d8b6a9e0fe7")],
          timeout: Duration(seconds: 3));

      var subscription = FlutterBluePlus.onScanResults.listen((results) async {
        ScanResult? fin;
        int? node;
        // Fluttertoast.showToast(msg: "Scanned ${results.length} devices");
        for (ScanResult r in results) {
          if (fin == null || r.rssi.abs() < fin.rssi.abs()) fin = r;
        }
        if (fin == null) return;
        // Fluttertoast.showToast(msg: "Located!!");
        int nodeId = int.parse(fin.advertisementData.advName.split(" ")[1]);
        if (!mounted) return;
        if (!context.read<NodeProvider>().nodes.containsKey(nodeId)) {
          return;
        }
        double newLat = context.read<NodeProvider>().nodes[nodeId]!.lat;
        double newLng = context.read<NodeProvider>().nodes[nodeId]!.lng;
        if (currentLat == newLat && currentLng == newLng) return;
        currentLat = newLat;
        currentLng = newLng;
        currentNode = nodeId;
        await updateLocation(pan: true);
        if (!located) {
          located = true;
          startListeningToNav();
        }
      });
    });
  }

  Future<void> updateLocation({bool pan = false}) async {
    final dbRef = FirebaseDatabase.instance.ref();
    await dbRef
        .child("Incidents")
        .child(widget.incidentId.toString())
        .child("UserLocs")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'lat': currentLat,
      'lng': currentLng,
      'nearestNode': currentNode,
      'canEscape': true,
    });
    uploadedOnce = true;
    _controller!.setUserLocation(currentLat, currentLng, 0, 0, true);
    if (pan) {
      _controller!.setCenter(LatLng(lat: currentLat, lng: currentLng),
          WoosPadding(bottom: 0, left: 0, right: 0, top: 0));
      _controller!.setZoom(19);
    }
  }

  void startListeningToNav() {
    s1 = FirebaseDatabase.instance
        .ref()
        .child("Incidents")
        .child(widget.incidentId.toString())
        .child("UserRoutes")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value == null) {
        requestRouting(
            widget.incidentId, FirebaseAuth.instance.currentUser!.uid);
        return;
      }
      for (var child in event.snapshot.children) {
        nodes.add(int.parse(child.value.toString()));
      }

      print("Ready!");

      // Determine how far along this route the user is
      int i = 0;
      for (i = 0; i < nodes.length; i++) {
        if (nodes[i] == currentNode) {
          break;
        }
      }
      // if (i == nodes.length) {
      //   requestRouting(
      //       widget.incidentId, FirebaseAuth.instance.currentUser!.uid);
      //   return;
      // }

      // Add markers for this route
      markers.forEach((element) async {
        await element.remove();
      });
      markers.clear();
      for (int j = i; j < nodes.length; j++) {
        print("Creating!!!!");
        int node = nodes[j];
        MarkerOptions options = MarkerOptions(
          position: LatLng(
              lat: context.read<NodeProvider>().nodes[node]!.lat,
              lng: context.read<NodeProvider>().nodes[node]!.lng),
          icon: WoosIcon(
              url:
                  "https://www.vhv.rs/dpng/d/600-6004318_map-marker-png-circle-transparent-png.png",
              scaledSize: WoosSize(height: 11, width: 11)),
        );
        var marker = Marker.create(options, _controller!);
        markers.add(marker);
        marker.add();
      }

      // For every consecutive nodes, add markers in between (after every 1m)
      for (int i = 0; i < nodes.length - 1; i++) {
        Node start = context.read<NodeProvider>().nodes[nodes[i]]!;
        Node end = context.read<NodeProvider>().nodes[nodes[i + 1]]!;
        double latDiff = (end.lat - start.lat) / 5;
        double lngDiff = (end.lng - start.lng) / 5;
        for (int j = 1; j < 5; j++) {
          MarkerOptions options = MarkerOptions(
            position: LatLng(
                lat: start.lat + j * latDiff, lng: start.lng + j * lngDiff),
            icon: WoosIcon(
                url:
                    "https://www.vhv.rs/dpng/d/600-6004318_map-marker-png-circle-transparent-png.png",
                scaledSize: WoosSize(height: 11, width: 11)),
          );
          var marker = Marker.create(options, _controller!);
          markers.add(marker);
          marker.add();
        }
      }
    });

    s2 = FirebaseDatabase.instance
        .ref()
        .child("Incidents")
        .child(widget.incidentId.toString())
        .child("RoutesMetadata")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      setState(() {
        if (event.snapshot.child("distance").value == null) {
          distance = null;
          time = null;
          type = null;
          return;
        }
        distance = "${event.snapshot.child("distance").value} metres";
        time = "${event.snapshot.child("time").value} minutes";
        type = event.snapshot.child("mode").value.toString();
      });
    });
  }

  void startFireService() {
    s3 = FirebaseDatabase.instance
        .ref()
        .child("Incidents")
        .child(widget.incidentId.toString())
        .child("Nodes")
        .child("FireNodes")
        .onValue
        .listen((event) {
      if (event.snapshot.value == null) return;
      for (var child in event.snapshot.children) {
        int nodeId = int.parse(child.key.toString());
        if (!context.read<NodeProvider>().nodes.containsKey(nodeId)) {
          return;
        }
        double newLat = context.read<NodeProvider>().nodes[nodeId]!.lat;
        double newLng = context.read<NodeProvider>().nodes[nodeId]!.lng;

        MarkerOptions options = MarkerOptions(
          position: LatLng(lat: newLat, lng: newLng),
          icon: WoosIcon(
            url: "https://www.svgrepo.com/show/405813/hollow-red-circle.svg",
            scaledSize: WoosSize(height: 40, width: 40),
          ),
        );
        var marker = Marker.create(options, _controller!);
        marker.add();
      }
    });
  }
}
