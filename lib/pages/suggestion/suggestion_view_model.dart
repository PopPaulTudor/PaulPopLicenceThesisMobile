import 'package:licenta/models/destionation.dart';
import 'package:licenta/models/reservation.dart';
import 'package:licenta/repo/reservation_repo.dart';
import 'package:licenta/repo/user_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionViewModel {
  final Input input;
  late Output output;

  late final ReservationRepo _reservationRepo;

  SuggestionViewModel(this.input) {
    output = Output(_onCreateReservation);
    _reservationRepo = ReservationRepo();
  }

  Stream<bool> get _onCreateReservation {
    return input.onCreateReservation.flatMap((reservation) =>
        SharedPreferences.getInstance().asStream().flatMap((pref) =>
        _reservationRepo.createReservation(pref.getString("email").toString(), reservation.startDate.millisecondsSinceEpoch, reservation.endDate.millisecondsSinceEpoch, reservation.destination.name)),);
  }

}


class Input {
  PublishSubject<Reservation> onCreateReservation;

  Input(this.onCreateReservation);
}

class Output {
  Stream<bool> onReservationCreated;

  Output(this.onReservationCreated);
}