import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  bool _isUserSignedIn = false;

  bool get isUserSignedIn => _isUserSignedIn;

  checkUserSignedIn()  {
    _isUserSignedIn = Auth.isUserSignedIn();
    notifyListeners();
  }

}
