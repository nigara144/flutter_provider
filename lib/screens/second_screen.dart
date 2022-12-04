import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/user_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class SecondScreen extends StatefulWidget {
  static String id = 'second_screen';
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool locationGranted = true;
  bool _canShowButton = true;
  bool changeText = false;
  int delayDuration = 2;
  Position? _currentPosition;
  DateTime startTime = DateTime.now();
  final _firestore = FirebaseFirestore.instance;

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await _firestore.collection('users').doc(prefs.getString('user_key')).delete();
    prefs.remove('user_key');
  }

  void hideStartButton() {
    setState(() {
      _canShowButton = !_canShowButton;
      changeText = !changeText;
    });
  }

  Future<void> isLocationGranted2() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
          setState(() => _currentPosition = position);
        }).catchError((e) {
          debugPrint(e);
        });
        setState(() {
          locationGranted = true;
        });
      } else {
        setState(() {
          locationGranted = false;
        });
      }
    }
  }

  Widget isLocationGranted() {
    isLocationGranted2();
    if (locationGranted) {
      return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'YOUR LOCATION: ${_currentPosition?.latitude ?? ""}, ${_currentPosition?.longitude ?? ""}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          elevation: 4.0,
          child: MaterialButton(
            onPressed: () async {
              Map<Permission, PermissionStatus> status =
                  await [Permission.location].request();
              print(status[Permission.location]);
              if (await Permission.location.isPermanentlyDenied) {
                openAppSettings();
              }
            },
            minWidth: 200.0,
            height: 42.0,
            child: const Text(
              'Allow location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime endTime = startTime.add(Duration(minutes: delayDuration));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/spaceship.png'),
                  height: 150,
                )
            ),
            Text(
              !changeText
                  ? 'Hello ${Provider.of<UserData>(context).firstName} ${Provider.of<UserData>(context).lastName}, how are you today?'
                  : 'The notification will appear at ${endTime.hour}:${endTime.minute}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            !_canShowButton
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: Colors.black87,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      elevation: 4.0,
                      child: MaterialButton(
                        minWidth: 200.0,
                        height: 42.0,
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async {
                          await Permission.notification.isDenied.then((value) {
                            if (value) {
                              Permission.notification.request();
                            } else {
                              hideStartButton();
                              localNoticeService!.addNotification(
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                elevation: 4.0,
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    removeUser();
                    Navigator.pushNamed(context, RegisterScreen.id);
                    },
                ),
              ),
            ),
            isLocationGranted()
          ],
        ),
      ),
    );
  }
}
