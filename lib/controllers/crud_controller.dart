import '../models/response.dart';

abstract class CRUD {
  Future<Result> add();
  Future<Result> change();
  Future<Result> delete();
}
