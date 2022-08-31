import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:licenta/models/subscription_state.dart';
import 'package:licenta/models/ui_model.dart';
import 'package:licenta/pages/feedback/feedback_page.dart';
import 'package:licenta/pages/home/home_view_model.dart';
import 'package:licenta/pages/login/login_page.dart';
import 'package:licenta/pages/profile/profile_screen.dart';
import 'package:licenta/pages/reservations/reservations_page.dart';
import 'package:licenta/pages/suggestion/suggestion_page.dart';
import 'package:licenta/theme/app_colors.dart';
import 'package:licenta/theme/curve_painter.dart';
import 'package:licenta/widgets/blurry_background.dart';
import 'package:licenta/widgets/circle_icon_button.dart';
import 'package:licenta/widgets/loading_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/see_more_element.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends SubscriptionState<MyHomePage> {
  late HomeViewModel _viewModel;
  bool showLoading = false;
  String town = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 3));

  @override
  void initState() {
    _viewModel = HomeViewModel(Input(
      PublishSubject(),
      PublishSubject(),
    ));
    super.initState();
    _bindViewModel();
    _viewModel.input.onLocationRequested.add(true);
  }

  void _bindViewModel() {
    disposeLater(
      _viewModel.output.onLocationDetermined.listen(
        (event) {
          // setState(() {
          //   showLoading = event.state == OperationState.loading;
          // });
          if (event.isSuccess) {
            setState(() {
              town = event.data!;
            });
          }
        },
      ),
    );
    disposeLater(
      _viewModel.output.onDestinationReturned.listen((event) {

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SuggestionPage(
              destinations: event,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        );
      }),
    );
  }

  String _getStringFromDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
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

                    Container(
                      padding: const EdgeInsets.only(top: 250, right: 200),
                      child: SvgPicture.asset("assets/trip.svg",
                          semanticsLabel: 'Trip'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleImageButton(
                                icon: Icons.person,
                                function: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => _viewModel
                                    .input.onLocationRequested
                                    .add(true),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 3.0),
                                          child: Icon(
                                            Icons.my_location,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: town,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: 'Raoul'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              CircleImageButton(
                                icon: Icons.logout,
                                function: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove("email");
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 30.0, bottom: 20),
                            child: Text(
                              "Start your journey",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          BlurryClickableContainer(
                              function: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime:
                                        DateTime.now().add(Duration(days: 365)),
                                    onChanged: (date) {}, onConfirm: (date) {
                                  setState(() {
                                    startDate = date;
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now()
                                            .add(Duration(days: 365)),
                                        onChanged: (date) {},
                                        onConfirm: (date) {
                                      setState(() {
                                        endDate = date;
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Text(
                                "${_getStringFromDate(startDate)} - ${_getStringFromDate(endDate)}",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                              intensity: 1.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 160.0, left: 250),
                            child: BlurryClickableContainer(
                                function: () {
                                  _viewModel.input.onDestinationRequested.add(
                                    PlanDates(
                                      startDate: startDate,
                                      endDate: endDate,
                                    ),
                                  );
                                },
                                child: const Text(
                                  "  Search  ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                intensity: 2.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 20),
                child: Text(
                  "Services",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              SeeMoreElement(
                  function: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReservationsPage(),
                      ),
                    );
                  },
                  text: "Review trips   ",
                  photoName: "suggestions"),
              Visibility(
                visible: false,
                child: SeeMoreElement(
                    function: () {},
                    text: "See all locations",
                    photoName: "town"),
              ),
              SeeMoreElement(
                  function: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FeedbackPage(),
                      ),
                    );
                  },
                  text: "Give me feedback",
                  photoName: "feedback"),
            ],
          ),
          Visibility(visible: false, child: LoadingWidget()),
        ],
      ),
    );
  }
}
