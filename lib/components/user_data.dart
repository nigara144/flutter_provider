import 'package:flutter/cupertino.dart';

class UserData extends ChangeNotifier {
 String? firstName;
 String? lastName;

 void changeFirstName(String newStr) {
  firstName = newStr;
  notifyListeners();
 }

 void changeLastName(String newStr) {
  lastName = newStr;
  notifyListeners();
 }
}