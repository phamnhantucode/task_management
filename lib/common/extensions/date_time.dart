import 'package:intl/intl.dart';
import 'package:room_master_app/common/constant.dart';

extension DateTimeX on DateTime {
  String get timeFormat => DateFormat(AppConstants.timeFormat).format(this);
  String get dateWeeksMonthFormat => DateFormat(AppConstants.dateWeeksMonthFormat).format(this);
}