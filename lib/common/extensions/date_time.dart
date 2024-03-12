import 'package:intl/intl.dart';
import 'package:room_master_app/common/constant.dart';

extension DateTimeX on DateTime {
  String get timeFormat => DateFormat(AppConstants.timeFormat).format(this);
}