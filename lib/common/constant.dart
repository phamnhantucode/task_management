class AppConstants {
  static const String timeFormat = 'HH:mm';
  static const List<String> monthsInYear = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  static const List<Map> taskInWeeksExample = [
    {'M': 12},
    {'T': 18},
    {'W': 22},
    {'T': 10},
    {'F': 12},
    {'S': 15},
    {'S': 22}
  ];
  static const String dateWeeksMonthFormat = 'EEEE, dd MMMM';
  static const String dateTimeFormat = 'dd MMMM, \'at\' HH:mm';
  static const String dateWeeksMonthYearFormat = 'EEE, dd MMM yyyy';

  static const String imageCloudStoragePath = 'images/';
  static const String fileCloudStoragePath = 'files/';

  static const String defaultUriAvatar = 'https://picsum.photos/200/300';
}
