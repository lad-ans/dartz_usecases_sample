import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular/flutter_modular_annotations.dart';

import '../../../../core/exceptions/login_failure.dart';
import '../../domain/repositories/login_repository.dart';

part 'login_repository.g.dart';

@Injectable()
class LoginRepositoryImpl implements ILoginRepository {
  @override
  Future<Either<LoginFailure, String>> login(
      String phone, String password) async {
    try {
      final Response response = await Dio().post(
        'https://www.vogu.xyz/login/phone',
        data: {'phone': '258' + phone, 'pin': password},
      );

      return right(response?.data['token']);
    } on DioError catch (dioErr) {
      if (dioErr?.response?.statusCode == 403) {
        return left(LoginNotFound());
      }
      return left(LoginServerError(message: dioErr.error));
    } catch (e) {
      return left(LoginServerError(message: e.error));
    }
  }
}
