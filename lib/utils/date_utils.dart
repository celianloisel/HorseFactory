getDateTimeString(DateTime dateTime) {
  dateTime = dateTime.toLocal();

  String year = dateTime.year.toString();
  String month = _convertUnitToTwoDigits(dateTime.month);
  String day = _convertUnitToTwoDigits(dateTime.day);

  String hour = _convertUnitToTwoDigits(dateTime.hour);
  String minute = _convertUnitToTwoDigits(dateTime.minute);

  return '$year-$month-$day $hour:$minute';
}

// "_" signifie que la fonction est privée
String _convertUnitToTwoDigits(int unit) {
  String unitString = unit.toString();
  if (unit < 10) unitString = '0$unitString';
  return unitString;
}
