import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isloading = false;
  bool get isloading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formkey.currentState?.validate());
    print('$email - $password');
    return formkey.currentState?.validate() ?? false;
  }
}
