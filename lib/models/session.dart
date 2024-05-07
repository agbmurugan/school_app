import 'biodata.dart';

class MySession {
  static final MySession _singleton = MySession._internal();

  int page = 0;
  bool? isAuthorized;
  Bio? bio;

  EntityType? get role => bio?.entityType;

  bool? isAdmin;

  factory MySession() {
    return _singleton;
  }

  MySession._internal();
}
