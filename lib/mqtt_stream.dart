import 'package:mqtt_client/mqtt_client.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'Mqtt_feed.dart';

class AppMqttTransactions {

  AppMqttTransactions() {

  }
  MqttClient client;

  String previousTopic;
  bool bAlreadySubscribed = false;
//////////////////////////////////////////
// Subscribe to an  mqtt topic.
  Future<bool> subscribe(String topic) async {
    if (await _connectToClient() == true) {
      /// Add the unsolicited disconnection callback
      client.onDisconnected = _onDisconnected;

      /// Add the successful connection callback
      client.onConnected = _onConnected;

      client.onSubscribed = _onSubscribed;
      _subscribe(topic);
    }
    return true;
  }

//
//
  Future<bool> _connectToClient() async {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
      //log.info('already logged in');
    } else {
      client = await _login();
      if (client == null) {
        return false;
      }
    }
    return true;
  }

  /// The subscribed callback
  void _onSubscribed(String topic) {
  //  log.info('Subscription confirmed for topic $topic');
    this.bAlreadySubscribed = true;
    this.previousTopic = topic;
  }

  /// The unsolicited disconnect callback
  void _onDisconnected() {
    //log.info('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      //log.info(':OnDisconnected callback is solicited, this is correct');
    }
    client.disconnect();
  }

  /// The successful connect callback
  void _onConnected() {
    //log.info('OnConnected client callback - Client connection was sucessful');
  }
  Future<Map> _getBrokerAndKey() async {
    // TODO: Check if private.json does not exist or expected key/values are not there.
    String connect = await rootBundle.loadString('config/private.json');
    return (json.decode(connect));
  }

  Future<MqttClient> _login() async {

    Map connectJson = await _getBrokerAndKey();

    client = MqttClient(connectJson['broker'], connectJson['key']);
    // Turn on mqtt package's logging while in test.
    client.logging(on: true);
    final MqttConnectMessage connMess = MqttConnectMessage()
        .authenticateAs(connectJson['username'], connectJson['password'])
        .withClientIdentifier('myClientID')
        .keepAliveFor(60) // Must agree with the keep alive set above or not set
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on Exception catch (e) {
      //log.severe('EXCEPTION::client exception - $e');
      client.disconnect();
      client = null;
      return client;
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
    } else {
      client.disconnect();
      client = null;
    }
    return client;
  }

  Future _subscribe(String topic) async {
    // for now hardcoding the topic
    if (this.bAlreadySubscribed == true) {
      client.unsubscribe(this.previousTopic);
    }
    //log.info('Subscribing to the topic $topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      MqttFeed.add(pt);
      return pt;
    });
  }

//////////////////////////////////////////
// Publish to an mqtt topic.
  Future<void> publish(String topic, String value) async {
    // Connect to the client if we haven't already
    if (await _connectToClient() == true) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(value);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);
    }
  }
}
