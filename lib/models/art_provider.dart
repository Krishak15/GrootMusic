import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtProvider with ChangeNotifier {
  bool isclicked = false;

  isc() async {
    SharedPreferences tr = await SharedPreferences.getInstance();
    var b = await tr.getBool('play');
    print("provider call${b}");

    if (b == true) {
      print("......................${b}");
      isclicked = true;
      notifyListeners();
    } else {
      isclicked = false;
      notifyListeners();
    }
    notifyListeners();
  }

  getdata() {}
}
