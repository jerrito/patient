import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/widgets/MainButton.dart';
import 'package:project/video_call/video.dart';

class VideoCallStartPage extends StatefulWidget {
  const VideoCallStartPage({super.key});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<VideoCallStartPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ayaresapa Video Call'),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 400,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _channelController,
                        decoration: InputDecoration(
                          errorText: _validateError
                              ? 'Channel name is mandatory'
                              : null,
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: 'Channel name',
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      title: Text(ClientRole.Broadcaster.toString()),
                      leading: Radio(
                        value: ClientRole.Broadcaster,
                        groupValue: _role,
                        onChanged: (ClientRole? value) {
                          setState(() {
                            _role = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(ClientRole.Audience.toString()),
                      leading: Radio(
                        value: ClientRole.Audience,
                        groupValue: _role,
                        onChanged: (ClientRole? value) {
                          setState(() {
                            _role = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SecondaryButton(
                          onPressed: onJoin,
                          color: Colors.pink,
                          backgroundColor: Colors.pink,
                          child: const Text('Join',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      // Expanded(
                      //   child: RaisedButton(
                      //     onPressed: onJoin,
                      //     child: Text('Join'),
                      //     color: Colors.blueAccent,
                      //     textColor: Colors.white,
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    //print(status);
  }
}
