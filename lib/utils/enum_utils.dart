import 'package:flutter/foundation.dart';

String getEnumValueString(enumValue) {
  String enumString = describeEnum(enumValue);

  String enumValueString = '';
  for (int i = 0; i < enumString.length; i++) {
    String char = enumString[i];
    if (char == char.toUpperCase()) {
      enumValueString += ' ';
    }
    if (i == 0) {
      enumValueString += char.toUpperCase();
      continue;
    }
    enumValueString += char;
  }
  return enumValueString;
}
