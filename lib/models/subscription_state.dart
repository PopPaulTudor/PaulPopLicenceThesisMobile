

import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class SubscriptionState<T extends StatefulWidget> extends State<T> {
  final List<StreamSubscription> _subscriptions = [];

  void disposeLater(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }

  void cancelSubscriptions() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}