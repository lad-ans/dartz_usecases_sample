import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/consts/const.dart';
import '../../core/exceptions/login_failure.dart';
import 'domain/repositories/login_repository.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final ILoginRepository _repository;
  _LoginControllerBase(this._repository);

  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @observable
  Option<LoginFailure> failure;

  @observable
  bool isLoading = false;

  @action
  Future<void> login() async {
    this.isLoading = true;
    this.failure = none();

    final loginResult =
        await _repository.login(phoneCtrl.text, passwordCtrl.text);

    loginResult.fold(
      (fail) {
        failure = optionOf(fail);
        this.isLoading = false;

        /// note: fail is the LoginFailure class of our request
      },
      (success) async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString(ACCESS_TOKEN, success);
        this.isLoading = false;
        Modular.to.pushNamedAndRemoveUntil('/', (_) => false);

        /// note: success is the response token of our request
      },
    );
  }
}
