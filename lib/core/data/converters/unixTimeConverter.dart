import 'package:intl/intl.dart';

String convertUnixToDate(int unixTimestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);

  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}
