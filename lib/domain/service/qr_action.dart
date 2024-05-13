import 'dart:developer';

import 'package:room_master_app/models/common/pair.dart';

enum QrAction {
  profile, joinGroup, joinProject;

  static const separateRegex = '_()_';

  String encode(String id) {
    return '$name$separateRegex$id';
  }

  static Pair<QrAction, String> decode(String code) {
    final pair = code.split(separateRegex);
    return Pair(QrAction.fromString(pair.first), pair.last);
  }

  @override
  String toString() {
    return switch (this) {
      QrAction.profile => 'profile',
      QrAction.joinGroup => 'joinGroup',
      QrAction.joinProject => 'joinProject',
    };
  }


  static QrAction fromString(String content) {
    switch (content) {
      case 'profile':
        return QrAction.profile;
      case 'joinGroup':
        return QrAction.profile;
      case 'joinProject':
        return QrAction.profile;
    }
    return QrAction.profile;
  }
}