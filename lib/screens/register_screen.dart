import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/components/user_data.dart';
import 'package:interview_app/screens/second_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firestore = FirebaseFirestore.instance;
  late String email, firstName , lastName, gender = 'male';
  int _value = 0;
  late UserData userData;

  Future<void> saveToSharedPreference(String docID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_key', docID);
  }

  @override
  void initState() {
    super.initState();
    userData = Provider.of<UserData>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  height: 60,
                )
            ),
            const Text('Sign Up',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your first name',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              onChanged: (value) {
                userData.changeFirstName(value);
                firstName = value;
                print('FIRSTNAME: $firstName');
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your last name',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              onChanged: (value) {
                userData.changeLastName(value);
                lastName = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
             TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
               onChanged: (value) {
                 email = value;
               },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text('Male'),
              leading: Radio(
                  value: 0,
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                      gender = 'male';
                    });
                  }),
            ),
            ListTile(
              title: Text('Female'),
              leading: Radio(
                  value: 1,
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                      gender = 'female';
                    });
                  }),
            ),
            ListTile(
              title: Text('Other'),
              leading: Radio(
                  value: 2,
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                      gender = 'other';
                    });
                  }),
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
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, SecondScreen.id);
                    var res = await _firestore.collection('users').add({
                      'firstName': firstName,
                      'lastName' : lastName,
                      'email' : email,
                      'gender' : gender
                    });
                    saveToSharedPreference(res.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
