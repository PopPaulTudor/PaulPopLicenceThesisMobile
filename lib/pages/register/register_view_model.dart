import 'dart:typed_data';

import 'package:licenta/models/ui_model.dart';
import 'package:licenta/repo/user_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterViewModel {
  final Input input;
  late final UserRepo _userRepo;
  late Output output;

  RegisterViewModel(this.input) {
    output = Output(_createAccount, _generateProfileOnImages);
    _userRepo = UserRepo();
  }

  Stream<UIModel<bool>> get _createAccount {
    return input.onCreateAccount.flatMap(
      (value) {
        return _userRepo
          .registerUser(value.email, value.password, value.phoneNumber)
          .map(
            (event) {
              return UIModel(OperationState.success, event, null);
            },
          );
      },
    );
  }

  Stream<String> get _generateProfileOnImages {
    return input.onRequestPhotos.flatMap(
      (value) => _userRepo.uploadImages(value.email, value.photos).flatMap((tags) =>
          SharedPreferences.getInstance().asStream().flatMap(
              (pref) => pref.setString("email", value.email).asStream().map((event) => tags))),
    );
  }
}

class Input {
  final Subject<CreateAccountData> onCreateAccount;
  final Subject<CreateAccountData> onRequestPhotos;

  Input(this.onCreateAccount, this.onRequestPhotos);
}

class Output {
  final Stream<UIModel<bool>> onLoginAnswer;
  final Stream<String> onProfileFinished;

  Output(this.onLoginAnswer, this.onProfileFinished);
}

class CreateAccountData {
  final String email;
  final String password;
  final String phoneNumber;
  final List<Uint8List> photos;

  CreateAccountData(this.email, this.password, this.phoneNumber, this.photos);
}
