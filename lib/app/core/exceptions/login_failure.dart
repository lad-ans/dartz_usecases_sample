class LoginFailure implements Exception {}

class LoginServerError extends LoginFailure {
  final String message;
  LoginServerError({this.message});
}

class LoginNotFound extends LoginFailure {}
