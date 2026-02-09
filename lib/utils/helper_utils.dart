int convertStringId(String id) {
  int sum = 1;

  final units = id.codeUnits;
  for (int i = 0; i < units.length; i++) {
    sum += units[i];
  }
  return sum;
}

final List<int> spacesPtrn = [2, 4, 7, 10];
String maskPhoneNum(num phone) {
  String s = phone.toString();
  String res = '';
  int cnr = 0;
  for (int i = 0; i < s.length; i++) {
    if (spacesPtrn.contains(cnr)) {
      res = ' $res';
    }
    res = s[s.length - 1 - i] + res;
    cnr++;
  }

  return '+$res';
}
