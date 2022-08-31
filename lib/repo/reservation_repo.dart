

import 'package:licenta/endpoint/reservation_endpoint.dart';
import 'package:licenta/models/reservation.dart';

class ReservationRepo{

  final ReservationEndpoint reservationEndpoint = ReservationEndpoint();

  Stream<bool> createReservation(String email, int startDate, int endDate, String name) {
    return reservationEndpoint.createReservation(email, startDate, endDate, name);
  }

  Stream<List<ReservationDTO>> getReservations() {
    return reservationEndpoint.getReservations();
  }


}