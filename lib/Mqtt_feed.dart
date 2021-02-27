import 'dart:async';
//import 'package:logging/logging.dart';

class MqttFeed {

  static var _feedController = StreamController<String>();
  // Expose the stream so a StreamBuilder and use it.
  static Stream<String> get subscribeStream => _feedController.stream;
//
// TODO: add takes in a string, but forces the feed to be an int
  static void add(String value) {

    try {
      _feedController.add(value);

    } catch (e) {

    }
  }
}
