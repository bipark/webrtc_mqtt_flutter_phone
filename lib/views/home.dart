//
//  main.dart
//  Created by Park Billy on 2021/12/05.
//  rtlink.park@gmail.com
//

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:uuid/uuid.dart';

import 'mqttman.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _topic = "webrtcphone";
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  final _clientId = Uuid().v1();

  MediaStream? _localStream;
  RTCPeerConnection? _localPc;
  RTCPeerConnection? _remotePc;
  MQTTManager? _mqtt;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await _initViewMqtt();

    _localPc = await _makePeerConnection();
  }

  Future<RTCPeerConnection> _makePeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        { 'urls': 'stun:stun.l.google.com:19302' },
      ],
      'sdpSemantics': 'unified-plan'
    };

    RTCPeerConnection pc = await createPeerConnection(configuration);
    pc.onIceConnectionState = (RTCIceConnectionState state) {
      setState(() {});
    };

    pc.onIceCandidate = (RTCIceCandidate candidate) async {
      await Future.delayed(Duration(milliseconds: 1000), () {
        final candidate1 = {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        };
        _sendData("candidate", candidate1);
      });
    };

    pc.onTrack = (RTCTrackEvent event) async {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };

    final mediaConstraints = <String, dynamic>{
      'audio': 'true',
      'video': {
        'mandatory': {
          'minWidth': '1280',
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'facingMode': 'user', //'user', // 'application'
        'optional': [],
      }
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
    _localStream!.getTracks().forEach((track) {
      setState(() {
        pc.addTrack(track, _localStream!);
      });
    });

    return pc;
  }

  Future<void> _initViewMqtt() async {
    _mqtt = MQTTManager(_clientId);
    await _mqtt!.connect(_topic);

    _mqtt!.client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final message = jsonDecode(pt);
      print(pt);

      if (message["command"] == "signal" && message["clientid"] != _clientId) {
        final message = jsonDecode(pt);
        _handleSocketSignalingData(message);
      }
    });
  }

  void _handleSocketSignalingData(data) async {

    switch (data["type"]) {
      case 'offer':
        {
          if (_remotePc == null) {
            _remotePc = await _makePeerConnection();
          }
          await _remotePc!.setRemoteDescription(RTCSessionDescription(data["data"], data["type"]));
          RTCSessionDescription desc = await _remotePc!.createAnswer();
          await _remotePc!.setLocalDescription(desc);
          _sendData("answer", desc.sdp);
        }
        break;
      case 'answer':
        {
          _localPc!.setRemoteDescription(RTCSessionDescription(data["data"], data["type"]));
          setState(() {});
        }
        break;
      case 'candidate':
        {
          final can1 = data["data"];
          RTCIceCandidate candidate = RTCIceCandidate(can1["candidate"], can1["sdpMid"], can1["sdpMLineIndex"]);
          _localPc!.addCandidate(candidate);
        }
        break;
    }
  }


  void _sendOffer() async {
    final offerSdpConstraints = <String, dynamic>{
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
    };

    var desc = await _localPc!.createOffer(offerSdpConstraints);
    await _localPc!.setLocalDescription(desc);
    _sendData("offer", desc.sdp);
  }

  void _sendData(event, data) {
    var request = Map();
    request["command"] = "signal";
    request["clientid"] = _clientId;
    request["type"] = event;
    request["data"] = data;
    _mqtt!.publishMessage(_topic, jsonEncode(request).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebRTC Phone"),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: RTCVideoView(_remoteRenderer),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            width: 100,
            height: 180,
            child: RTCVideoView(_localRenderer),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendOffer,
        child: const Icon(Icons.phone_in_talk_outlined),
      ),
    );
  }
}
