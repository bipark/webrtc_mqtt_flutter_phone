//
//  main.dart
//  Created by Park Billy on 2021/12/05.
//  rtlink.park@gmail.com
//

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


class MQTTManager {
  MqttServerClient? _client;

  MQTTManager(String clientId) {
    _client = MqttServerClient("test.mosquitto.org", clientId);
    _client!.autoReconnect = true;
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 20;
  }

  Future<void> connect(String topic) async {
    try {
      await _client!.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
    }
    _client!.subscribe(topic, MqttQos.atMostOnce);
  }

  void publishMessage(String topic ,String message) {
    try {
      final builder1 = MqttClientPayloadBuilder();
      builder1.addString(message);
      _client!.publishMessage(topic, MqttQos.atLeastOnce, builder1.payload!);
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
    }
  }

  void subscribeTopic(String topic) {
    _client!.subscribe(topic, MqttQos.atMostOnce);
  }

  void unSubscribeTopic(String topic) {
    _client!.unsubscribe(topic);
  }

  void disconnect() {
    _client!.disconnect();
  }

  get client => _client;
}