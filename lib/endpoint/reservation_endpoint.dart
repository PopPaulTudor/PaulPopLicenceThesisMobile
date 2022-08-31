import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:licenta/models/reservation.dart';

class ReservationEndpoint {
  String hostname = "192.168.0.103:8080";

  Stream<bool> createReservation(
      String email, int startDate, int endDate, String name) {
    var url = Uri.http(hostname, '/api/reservations/create');
    Map<String, String> body = {
      'email': email,
      'name': name,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
    };
    return http
        .post(url, body: json.encode(body), headers: {
          "accept": "application/json",
          "content-type": "application/json"
        })
        .asStream()
        .map((response) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');

          return response.statusCode == 200;
        });
  }

  Stream<List<ReservationDTO>> getReservations() {
    var url = Uri.http(hostname, '/api/reservations');

    return http
        .get(url, headers: {
          "accept": "application/json",
          "content-type": "application/json"
        })
        .asStream()
        .map((response) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');

          Iterable l = json.decode(response.body);
          List<ReservationDTO> destinations = List<ReservationDTO>.from(
            l.map((model) {
              return ReservationDTO(model["name"], model["startDate"],
                  model["endDate"], model["email"]);
            }),
          );
          return destinations;
        });
  }
}
