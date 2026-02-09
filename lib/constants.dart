import 'package:shared_preferences/shared_preferences.dart';

class VersionConstant {
  static bool free = false;
  static var isPaidSubscription = false;
  static printBool() {
    print(isPaidSubscription);
  }

  static changeBool() {
    isPaidSubscription = !isPaidSubscription;
    printBool();
  }
}

class Constants {
  static String kApiDefaultUrl = 'http://178.20.45.23/api';
}

class TipyHelp {
  static var helpName = "С вами свяжутся по телефону или напишут в сообщениях";
  static printString() {
    print(helpName);
  }

  static changeHelp(String tipyHelp) {
    helpName = tipyHelp;
    printString();
  }
}

class WhoCall {
  static var callName = "ВРАЧ ВЫЗВАН";
  static printString() {
    print(callName);
  }

  static changeWho(String tipyHelp) {
    callName = tipyHelp;
    printString();
  }
}

class AfterPay {
  static var whereCall = "Смайлик";
  static printString() {
    print(whereCall);
  }

  static changeAfterMinute() {
    whereCall = "Минуты";
    printString();
  }

  static changeAfterSmile() {
    whereCall = "Смайлик";
    printString();
  }
}
