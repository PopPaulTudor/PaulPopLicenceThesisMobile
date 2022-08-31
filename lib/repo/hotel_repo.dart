
import 'package:licenta/endpoint/hotel_endpoint.dart';
import 'package:licenta/models/destionation.dart';

class HotelRepo{

  final HotelEndpoint _hotelEndpoint = HotelEndpoint();

  Stream<List<Destination>> getRecommendations(double long, double lat, int startDate, int endDate, String email){
    return _hotelEndpoint.getRecommendations(long, lat, startDate, endDate,email);
  }

}