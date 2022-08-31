import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:licenta/models/destionation.dart';
import 'package:licenta/models/reservation.dart';
import 'package:licenta/models/subscription_state.dart';
import 'package:licenta/pages/suggestion/suggestion_view_model.dart';
import 'package:licenta/theme/app_colors.dart';
import 'package:licenta/theme/curve_painter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';

class SuggestionPage extends StatefulWidget {
  final List<Destination> destinations;
  final DateTime startDate;
  final DateTime endDate;

  double get maximum {
    double max = 1;
    for (var element in destinations) {
      if (max < element.similarity) {
        max = element.similarity;
      }
    }
    return max;
  }

  const SuggestionPage({
    Key? key,
    required this.destinations,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends SubscriptionState<SuggestionPage> {
  int selectedIndex = 0;
  late final SuggestionViewModel _suggestionViewModel;


  @override
  void initState() {
    _suggestionViewModel = SuggestionViewModel(Input(PublishSubject()));
    disposeLater(
      _suggestionViewModel.output.onReservationCreated.listen((event) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Reservation made"),
          ),
        );
        Navigator.of(context).pop();
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 500,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return widget.destinations
                      .map((e) => Stack(children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: CustomPaint(
                                painter: CurvePainter(),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 7.0,
                                        percent: e.similarity / widget.maximum,
                                        center: Text(
                                          "Match",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        progressColor: Colors.blue,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "Rating:\n" + e.score.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 80.0),
                                  child: Text(
                                    e.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  child: Text(
                                    e.address,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  child: Text(
                                    e.desc.replaceAll(",", ", "),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]))
                      .toList()[index];
                },
                onIndexChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                // itemCount: widget.destinations.length,
                itemCount: widget.destinations.length,
                viewportFraction: 0.8,
                scale: 0.9,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                _suggestionViewModel.input.onCreateReservation.add(Reservation(
                    widget.destinations.elementAt(selectedIndex),
                    widget.startDate,
                    widget.endDate,
                    ""));
              },
              child: Text("Select"),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 20, horizontal: 100)),
                backgroundColor:
                    MaterialStateProperty.all(AppColors.primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
