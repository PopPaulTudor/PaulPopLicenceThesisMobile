import 'package:licenta/models/ui_model.dart';
import 'package:licenta/repo/user_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  final Input input;
  late Output output;
  late final UserRepo _userRepo;


  LoginViewModel(this.input) {
    output = Output(_login);
    _userRepo = UserRepo();
  }

    Stream<bool> get _login {
      return input.onLoginRequested.flatMap(
            (value) => _userRepo.loginUser(value.email, value.password).flatMap((resp) =>
            SharedPreferences.getInstance().asStream().flatMap(
                    (pref) => pref.setString("email", value.email).asStream().map((event) => resp))),
      );
    }
}

class Input {
  final Subject<LoginData> onLoginRequested;

  Input(this.onLoginRequested);
}

class Output {
  final Stream<bool> onLoginAnswer;

  Output(this.onLoginAnswer);
}

class LoginData{
  final String email;
  final String password;

  LoginData(this.email, this.password);
}