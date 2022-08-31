

import 'package:licenta/models/reservation.dart';
import 'package:licenta/repo/reservation_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationViewMode{
  final Input input;
  late Output output;

  late final ReservationRepo _reservationRepo;

  ReservationViewMode(this.input) {
    output = Output(_onGetReservations);
    _reservationRepo = ReservationRepo();
  }

  Stream<List<ReservationDTO>> get _onGetReservations {
    return input.onGetReservations.flatMap((reservation) =>
            _reservationRepo.getReservations());
  }
}

class Input{
  final PublishSubject<bool> onGetReservations;

  Input(this.onGetReservations);
}

class Output{

  final Stream<List<ReservationDTO>> onListReservations;

  Output(this.onListReservations);

}