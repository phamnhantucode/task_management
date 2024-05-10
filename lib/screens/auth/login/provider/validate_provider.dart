import 'package:flutter/cupertino.dart';

class ValidateProvide extends ChangeNotifier{
  RegExp strongPassword = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');

  RegExp emailRequirement = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  validator(String value, String message){
    if(value.isEmpty){
      return message;
    }else{
      return null;
    }
  }
  passwordValidator(String value){
    if(value.isEmpty){
      return "Password is required";
    // }else if(!strongPassword.hasMatch(value)){
    //   return "Password is not strong enough";
    }else if(value.length < 6){
      return 'Password must be at least 6 characters long';
    }
    else{
      return null;
    }
  }

  confirmPass(String value1, String value2) {
    if (value1.isEmpty) {
      return "Re-enter your password";
    } else if (value1 != value2) {
      return "Passwords don't match";
    } else {
      return null;
    }
  }
  emailValidator(String value){
    if(value.isEmpty){
      return "Email is required";
    }else if(!emailRequirement.hasMatch(value)){
      return "Email is not valid";
    }else{
      return null;
    }
  }

}