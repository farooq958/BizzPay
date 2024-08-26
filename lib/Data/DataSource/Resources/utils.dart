import 'package:flutter/cupertino.dart';

class Utils {
  static const String Dropshipping = '';

  static String formatPrice(int value) {
    print("here is value $value");

    if (value >= 1000000) {
      double millions = value / 1000000;
      return '${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 2)}M';
    } else if (value >= 1000) {
      double thousands = value / 1000;
      return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 2)}K';
    } else {
      return value.toString();
    }
  }
}
