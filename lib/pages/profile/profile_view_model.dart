import 'package:licenta/models/user.dart';
import 'package:licenta/repo/user_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel {
  final Input input;
  late final UserRepo _userRepo;
  late Output output;

  ProfileViewModel(this.input) {
    output = Output(_getProfile);
    _userRepo = UserRepo();
  }

  Stream<User> get _getProfile {
    return input.onRequestAccount.flatMap(
      (event) => SharedPreferences.getInstance().asStream().flatMap(
            (pref) => _userRepo.getProfile(
              pref.getString("email")!,
            ),
          ),
    );
  }
}

class Input {
  final Subject<bool> onRequestAccount;

  Input(this.onRequestAccount);
}

class Output {
  final Stream<User> onProfileInformation;

  Output(this.onProfileInformation);
}
