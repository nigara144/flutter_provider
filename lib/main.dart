
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/screens/register_screen.dart';
import 'package:interview_app/screens/second_screen.dart';
import 'package:provider/provider.dart';
import 'Utils/local_notice_service.dart';
import 'components/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
LocalNoticeService? localNoticeService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  localNoticeService = LocalNoticeService.e();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  bool? getFromSharedPreference() {
    return prefs?.containsKey('user_key');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>(
      create: (BuildContext context) => UserData(),
       child: MaterialApp(
         initialRoute: !getFromSharedPreference()! ? RegisterScreen.id : SecondScreen.id,
         routes: {
           RegisterScreen.id: (context) => RegisterScreen(),
           SecondScreen.id: (context) => SecondScreen()
         },
       ),
    );

  }
}

