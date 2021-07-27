import 'generatePassword.dart';
import 'global.dart';

bool checkPassword(String value, bool small, bool capital, bool number, bool special) {
  String? pattern;
  if (small == true && capital == true && number == true && special == true) {
    pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }

  if (small == false && capital == true && number == true && special == true) {
    pattern =
        r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }

  if (small == true && capital == false && number == true && special == true) {
    pattern =
        r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }

  if (small == true && capital == true && number == false && special == true) {
    pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }

  if (small == true && capital == true && number == true && special == false) {
    pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{10,}$';
  }

  if (small == false && capital == false && number == true && special == true) {
    pattern = r'^(?=.*?[0-9])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }
  if (small == false && capital == true && number == false && special == true) {
    pattern = r'^(?=.*?[A-Z])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }
  if (small == false && capital == true && number == true && special == false) {
    pattern = r'^(?=.*?[A-Z])(?=.*?[0-9]).{10,}$';
  }
  if (small == true && capital == false && number == false && special == true) {
    pattern = r'^(?=.*?[a-z])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }
  if (small == true && capital == false && number == true && special == false) {
    pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{10,}$';
  }
  if (small == true && capital == true && number == false && special == false) {
    pattern = r'^(?=.*?[A-Z])(?=.*?[a-z]).{10,}$';
  }
  if (small == false &&
      capital == false &&
      number == false &&
      special == true) {
    pattern = r'^(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{10,}$';
  }
  if (small == true &&
      capital == false &&
      number == false &&
      special == false) {
    pattern = r'^(?=.*?[a-z]).{10,}$';
  }
  if (small == false &&
      capital == true &&
      number == false &&
      special == false) {
    pattern = r'^(?=.*?[A-Z]).{10,}$';
  }
  if (small == false &&
      capital == false &&
      number == true &&
      special == false) {
    pattern = r'^(?=.*?[0-9]).{10,}$';
  }
  RegExp regExp = new RegExp(pattern!);
  return regExp.hasMatch(value);
}

validate(bool smallLetters, bool capitalLetters, bool numbers,
    bool specialCharacters, int passwordLenth) {
  if (smallLetters == false &&
      capitalLetters == false &&
      numbers == false &&
      specialCharacters == false) {
    generatedPassword = '';
  } else {
    var validPassword = generatePassword(smallLetters, capitalLetters, numbers,
        specialCharacters, passwordLenth.toDouble());
    while (!checkPassword(validPassword, smallLetters, capitalLetters, numbers,
        specialCharacters)) {
      validPassword = generatePassword(smallLetters, capitalLetters, numbers,
          specialCharacters, passwordLenth.toDouble());
    }
    generatedPassword = validPassword;
  }
}