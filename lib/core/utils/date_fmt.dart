import 'package:intl/intl.dart';

class DateFmt {
  static String short(DateTime? dt) {
    if (dt == null) return "No due date";
    return DateFormat('dd MMM, yyyy').format(dt);
  }
}
