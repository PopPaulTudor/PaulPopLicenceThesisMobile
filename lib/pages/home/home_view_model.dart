import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:licenta/models/destionation.dart';
import 'package:licenta/models/ui_model.dart';
import 'package:licenta/repo/hotel_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel {
  final Input input;
  late Output output;
  late Position? locality;
  late final HotelRepo _hotelRepo;

  HomeViewModel(this.input) {
    _hotelRepo = HotelRepo();
    output = Output(_getLocation, _getDestinations);
  }

  Stream<UIModel<String>> get _getLocation {
    return input.onLocationRequested
        .flatMap((_) => _determinePosition().flatMap((event) {
              if (event.isSuccess) {
                locality = event.data;

                return placemarkFromCoordinates(
                        event.data!.latitude, event.data!.longitude,
                        localeIdentifier: "en")
                    .asStream()
                    .map((event) => UIModel.success(event[0].locality!));
              } else {
                return Stream.value(UIModel(event.state, "", event.error));
              }
            }).startWith(UIModel.loading()));
  }

  Stream<UIModel<Position>> _determinePosition() {
    return Geolocator.isLocationServiceEnabled()
        .asStream()
        .flatMap((serviceEnabled) {
      if (!serviceEnabled) {
        return Stream.value(UIModel.error('Location services are disabled.'));
      }

      return Geolocator.checkPermission().asStream().flatMap((permission) {
        if (permission == LocationPermission.denied) {
          return Geolocator.requestPermission().asStream().flatMap((event) {
            if (event == LocationPermission.denied) {
              return Stream.value(
                  UIModel.error('Location permissions are denied'));
            } else {
              return Geolocator.getCurrentPosition()
                  .asStream()
                  .map((event) => UIModel.success(event));
            }
          });
        } else {
          if (permission == LocationPermission.deniedForever) {
            return Stream.value(
              UIModel.error(
                  'Location permissions are permanently denied, we cannot request permissions.'),
            );
          }

          return Geolocator.getCurrentPosition().asStream().map(
                (event) => UIModel.success(event),
              );
        }
      });
    });
  }

  Stream<List<Destination>> get _getDestinations {
    return input.onDestinationRequested.flatMap(
      (value) => SharedPreferences.getInstance().asStream().flatMap(
            (pref) => _hotelRepo.getRecommendations(
              locality == null ? 40.0 : locality!.longitude ,
              locality == null ? 40.0 : locality!.latitude ,
              value.startDate.millisecondsSinceEpoch,
              value.endDate.millisecondsSinceEpoch,
              pref.getString("email")!,
            ),
          ),
    );
  }
}

class Input {
  final Subject<bool> onLocationRequested;
  final Subject<PlanDates> onDestinationRequested;

  Input(this.onLocationRequested, this.onDestinationRequested);
}

class Output {
  final Stream<UIModel<String>> onLocationDetermined;
  final Stream<List<Destination>> onDestinationReturned;

  Output(this.onLocationDetermined, this.onDestinationReturned);
}

class PlanDates {
  final DateTime startDate;
  final DateTime endDate;

  PlanDates({
    required this.startDate,
    required this.endDate,
  });
}
