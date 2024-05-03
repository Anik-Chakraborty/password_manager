class Validate{

  static String? phoneNo(String value){
    if(value.isEmpty){
      return 'Enter Phone No';
    }
    else{
      return null;
    }
  }

  static String? email(String value){
    if(value.isEmpty){
      return null;
    }
    else{
      bool isValid = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(value);
      if (isValid) {
        return null;
      }
      else{
        return 'Enter Valid Email';
      }
    }
  }

  static String? fullName(String value){
    if(value.isEmpty){
      return 'Enter Full Name';
    }
    else{
      return null;
    }
  }

  static String? password(String value){
    if(value.isEmpty){
      return 'Enter Password';
    }
    else if(value.length < 6){
      return 'Min length of password is 6';
    }
    else{
      return null;
    }
  }

  static String? confirmPassword(String password, String confirmPassword){
    if(confirmPassword.isEmpty){
      return 'Enter Confirm Password';
    }
    else if(confirmPassword.length < 6){
      return 'Min length of password is 6';
    }
    else if(confirmPassword != password){
      if(password.isEmpty){
        return 'Enter Password';
      }
      return 'Passwords is not matching';
    }
    else{
      return null;
    }
  }

}