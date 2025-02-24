import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firefly_user/main.dart';
import 'package:firefly_user/pages/dashboard/main.dart';
import 'package:firefly_user/pages/sos/main.dart';
import 'package:firefly_user/pages/sos/navigation.dart';
import 'package:firefly_user/providers/node.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntermediateSosPage extends StatefulWidget {
  final int incidentId;
  const IntermediateSosPage(this.incidentId, {super.key});

  @override
  State<IntermediateSosPage> createState() => _IntermediateSosPageState();
}

class _IntermediateSosPageState extends State<IntermediateSosPage> {
  int remSeconds = 15;
  late Timer timer;

  void createCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (remSeconds > 0) {
          remSeconds--;
        } else {
          timer.cancel();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationPage(widget.incidentId)));
        }
      });
    });
  }

  // Override the initState method to start the countdown
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createCountdown();
  }

  // Override the dispose method to cancel the countdown
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/fire_icon.png",
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Fire Alert for Amity University (AUC)!",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green,
                        ),
                        elevation: MaterialStateProperty.all(4),
                      ),
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NavigationPage(widget.incidentId)));
                      },
                      child: Text(
                        'Navigate to Safety ($remSeconds)',
                        style:
                            TextStyle(color: Color(0xFFF9F8FD), fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        elevation: MaterialStateProperty.all(4),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'I\'m not inside',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
