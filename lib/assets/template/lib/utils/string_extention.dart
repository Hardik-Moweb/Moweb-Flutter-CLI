import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

extension FormatedDate on String {
  bool get isEmailValidated {
    return RegExp(
            r"^[a-zA-Z0-9.~!?#$%^&*_-]+@[a-zA-Z0-9~!?#$%^&*_-]+\.[a-zA-Z~!?#$%^&*_-]+")
        .hasMatch(this);
  }

  String convertDateFormat() {
    if (this == "" || this == "-") {
      return "-";
    }
    String? formate = dotenv.env['DISPLAYDATEFORMATE'];
    if (formate == null) return this;
    
    DateFormat newDateFormat = DateFormat(formate);
    DateFormat currentFormate = DateFormat("yyyy-MM-dd");
    try {
      DateTime dateTime = currentFormate.parse(this);
      String selectedDate = newDateFormat.format(dateTime);
      return selectedDate;
    } catch (e) {
      return this;
    }
  }

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  num formatDecimal() {
    return num.tryParse(
          replaceAll(
            ",",
            "",
          ),
        ) ??
        0;
  }
}
