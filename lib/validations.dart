
//Validation methods for login and registration form

//to validate email field
emailValidation(String? val, String? hint ){
  if(val!.isEmpty)
    return "Please Enter $hint";
  else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val))
    return "Enter valid email";
  else
    return null;
}

//to validate password field
passwordValidation(String? val, String? hint){
  if(val!.isEmpty)
    return "Please Enter $hint";
  else if(val.length<6)
    return "Password should be 6 characters long";
  else
    return null;
}

//to validate that field is not empty
emptyValidation(String? val, String? hint){
  if(val!.isEmpty)
    return "Please Enter $hint";
  else
    return null;
}
