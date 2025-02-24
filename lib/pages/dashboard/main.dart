import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firefly_user/apis/building.dart';
import 'package:firefly_user/apis/node.dart';
import 'package:firefly_user/apis/user.dart';
import 'package:firefly_user/models/node.dart';
import 'package:firefly_user/pages/ble_test/main.dart';
import 'package:firefly_user/pages/nav_test/main.dart';
import 'package:firefly_user/pages/sos/main.dart';
import 'package:firefly_user/providers/building.dart';
import 'package:firefly_user/providers/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:woosmap_flutter/woosmap_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  WoosmapController? _woosmapController;
  double currentLat = 21.396257771528767;
  double currentLng = 81.8924732178138;

  void fetchData() async {
    context.read<BuildingProvider>().setBuilding(await getBuildingById(1));
    if (context.read<BuildingProvider>().building!.isOnFire) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => IntermediateSosPage(
                  context.read<BuildingProvider>().building!.incidentId!)));
    }
    final firebaseToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    Map<int, Node> nodes = await getAllNodesForBuilding(firebaseToken!, 1);
    context.read<NodeProvider>().setNodes(nodes);

    // Set location at random node for now
    // TODO: Change later
    currentLat = nodes.entries.first.value.lat;
    currentLng = nodes.entries.first.value.lng;
    updateLocation(pan: true);
  }

  void updateLocation({bool pan = false}) {
    _woosmapController!.setUserLocation(currentLat, currentLng, 0, 0, true);
    if (pan) {
      _woosmapController!.setCenter(LatLng(lat: currentLat, lng: currentLng),
          WoosPadding(bottom: 0, left: 0, right: 0, top: 0));
      _woosmapController!.setZoom(19);
    }
  }

  void initializeFcm() async {
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);

    FirebaseMessaging.instance.getToken().then((fcmToken) async {
      if (fcmToken == null) {
        print("XXXXXXXXXXX");
        return;
      }
      updateFcmToken(
          (await FirebaseAuth.instance.currentUser!.getIdToken())!, fcmToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // GPSService((lat, long) {
      // Check how far they are
      confirmIncident((await FirebaseAuth.instance.currentUser!.getIdToken())!,
          int.parse(message.data['incidentId']));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  IntermediateSosPage(int.parse(message.data['incidentId']))));
    });

    // FirebaseMessaging.onBackgroundMessage(handleBackgroundFcm);
    //});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    initializeFcm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          WoosmapMapViewWidget.create(
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SimpleShadow(
              sigma: 5,
              child: BottomSheet(
                onClosing: () {},
                builder: (context) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding:
                              EdgeInsets.only(left: 20, top: 15, bottom: 2),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "You are in:\t\t",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: 'Avenir',
                                    )),
                                TextSpan(
                                  text: context
                                              .watch<BuildingProvider>()
                                              .building ==
                                          null
                                      ? "Loading..."
                                      : context
                                          .watch<BuildingProvider>()
                                          .building!
                                          .name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: 'Avenir'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 20, bottom: 5),
                          child: Text(
                            context.watch<BuildingProvider>().building == null
                                ? "Please wait"
                                : context
                                    .watch<BuildingProvider>()
                                    .building!
                                    .address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(12)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.grey,
                                      ),
                                      elevation: MaterialStateProperty.all(4),
                                    ),
                                    child: Text(
                                      'Test BLE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BleTestPage(),
                                        ),
                                      );
                                    }
                                    // widget.onBlePressed,
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(12)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.green,
                                      ),
                                      elevation: MaterialStateProperty.all(4),
                                    ),
                                    child: Text(
                                      'Explore',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Avenir'),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              IntermediateSosPage(74),
                                        ),
                                      );
                                    }
                                    // widget.onExplorePressed,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(12)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary,
                                ),
                                elevation: MaterialStateProperty.all(4),
                              ),
                              child: Text(
                                'SOS',
                                style: TextStyle(
                                  color: Color(0xFFF9F8FD),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            IntermediateSosPage(69)));
                              }
                              // widget.onSosPressed,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  void startBleService() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      FlutterBluePlus.startScan(
          withServices: [Guid("bf27730d-860a-4e09-889c-2d8b6a9e0fe7")],
          timeout: Duration(seconds: 3));

      var subscription = FlutterBluePlus.onScanResults.listen((results) async {
        ScanResult? fin;
        // Fluttertoast.showToast(msg: "Scanned ${results.length} devices");
        for (ScanResult r in results) {
          if (fin == null || r.rssi.abs() < fin.rssi.abs()) fin = r;
        }
        if (fin == null) return;
        // Fluttertoast.showToast(msg: "Located!!");
        int nodeId = int.parse(fin.advertisementData.advName.split(" ")[1]);
        if (!context.read<NodeProvider>().nodes.containsKey(nodeId)) {
          return;
        }
        double newLat = context.read<NodeProvider>().nodes[nodeId]!.lat;
        double newLng = context.read<NodeProvider>().nodes[nodeId]!.lng;
        if (currentLat == newLat && currentLng == newLng) return;
        currentLat = newLat;
        currentLng = newLng;
        updateLocation(pan: true);
      });
    });
  }

  void onVenueLoaded() {
    updateLocation(pan: true);
    startBleService();
    // _woosmapController!.setUserLocation(initialLat, initialLng, 0, 0, true);
    // // _controller!.mapOptions!.center =
    // //     LatLng(lat: 28.628569596568086, lng: 77.18906970982692);
    // _woosmapController!.setZoom(19);

    // _woosmapController!.setCenter(LatLng(lat: initialLat, lng: initialLng),
    //     WoosPadding(bottom: 0, left: 0, right: 0, top: 0));
  }
}
