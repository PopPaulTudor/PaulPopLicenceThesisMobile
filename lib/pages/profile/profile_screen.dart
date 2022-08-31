import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:licenta/models/subscription_state.dart';
import 'package:licenta/models/user.dart';
import 'package:licenta/pages/profile/profile_view_model.dart';
import 'package:licenta/theme/app_colors.dart';
import 'package:rxdart/rxdart.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends SubscriptionState<ProfileScreen> {
  late ProfileViewModel _viewModel;
  late User user = User(labels: '', email: '', phoneNumber: '');

  List<String> get _labels {
    List<String> labels = [];
    if (user.labels == "") {
      return labels;
    }
    if (user.labels.endsWith(', ')) {
      user.labels = user.labels.substring(0, user.labels.length - 2);
    }
    user.labels.split(",").forEach((element) {
      element = element.toUpperCase();
      labels.add(element);
    });

    return labels;
  }

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(Input(PublishSubject()));

    disposeLater(
      _viewModel.output.onProfileInformation.listen((event) {
        setState(() {
          user = event;
        });
      }),
    );
    _viewModel.input.onRequestAccount.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  child: Text(
                    user.email.toUpperCase() + "\n" + user.phoneNumber.toUpperCase(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: _labels
                      .map(
                        (e) => Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppColors.powderBlue,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: Center(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                              child: Text(
                                e,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
