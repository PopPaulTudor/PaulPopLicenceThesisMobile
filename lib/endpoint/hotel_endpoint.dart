import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:licenta/models/destionation.dart';

class HotelEndpoint{
  String hostname = "192.168.0.103:8080";

  Stream<List<Destination>> getRecommendations(double long, double lat, int startDate, int endDate, String email){
    var url = Uri.http(hostname, '/api/hotels/recommend');
    Map<String, String> body = {
      'longitude': long.toString(),
      'latitude': lat.toString(),
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'email': email,
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
      Iterable l = json.decode(response.body);
      List<Destination> destinations = List<Destination>.from(l.map((model) {
        return Destination(model["name"], model["score"], model["address"], model["similarity"], model["desc"]);
      }));
      return destinations;
    });

  }
}