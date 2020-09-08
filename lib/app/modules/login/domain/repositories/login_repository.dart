import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/login_failure.dart';

abstract class ILoginRepository {
  Future<Either<LoginFailure, String>> login(String phone, String password);
}