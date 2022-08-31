
import 'package:licenta/models/destionation.dart';

class Reservation{

  final Destination destination;
  final DateTime startDate;
  final DateTime endDate;
  final String email;

  Reservation(this.destination, this.startDate, this.endDate, this.email);
}

class ReservationDTO{
  final String name;
  final int startDate;
  final int endDate;
  final String email;

  ReservationDTO(this.name, this.startDate, this.endDate, this.email);
}