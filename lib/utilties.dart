import 'package:intl/intl.dart';

final DateFormat dateFormatter = DateFormat('MMMM dd, yyyy');

String prettyDate(String dateStr) {
  return dateFormatter.format(DateTime.parse(dateStr));
}
