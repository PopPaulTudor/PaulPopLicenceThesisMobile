import 'package:flutter/material.dart';
import 'package:licenta/models/reservation.dart';
import 'package:licenta/models/subscription_state.dart';
import 'package:licenta/pages/reservations/reservations_view_model.dart';
import 'package:licenta/theme/app_colors.dart';
import 'package:rxdart/subjects.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends SubscriptionState<ReservationsPage> {
  late final ReservationViewMode _reservationViewMode;
  List<ReservationDTO> list = [];

  @override
  void initState() {
    _reservationViewMode = ReservationViewMode(Input(PublishSubject()));
    disposeLater(_reservationViewMode.output.onListReservations.listen((event) {
      setState(() {
        list = event;
      });
    }));
    super.initState();
    _reservationViewMode.input.onGetReservations.add(true);
  }

  String getText(int milli){
    DateTime time = DateTime.fromMillisecondsSinceEpoch(milli);

    return time.year.toString() + "/" + time.month.toString() + "/" + time.day.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: list
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.powderBlue,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DefaultTextStyle(style: TextStyle(color: Colors.black, fontSize: 30), child: Text(e.name)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DefaultTextStyle(style: TextStyle(color: Colors.black, fontSize: 20), child: Text(getText(e.startDate))),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DefaultTextStyle(style: TextStyle(color: Colors.black, fontSize: 20), child: Text(getText(e.endDate))),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
