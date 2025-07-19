import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:hab_auth/services/otp_generator_service.dart';

class AccountTile extends StatefulWidget {
  const AccountTile({super.key});
  @override
  _AccountTileState createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  int _timeRemaining = 30;
  final otpService = OtpGeneratorService();
  String otpCodeString = "123456";
  final _countdownController = CountDownController();
  Timer? _timer;
  

  void copyOtpToClipboard() async{
    try {
      await FlutterClipboard.copy(otpCodeString);
    } on ClipboardException catch (e) {
      debugPrint(e.toString());
    }
  }
  void deleteAuth() {

  }

  @override 
  void initState() {
    super.initState();
    otpCodeString = otpService.generateOtp();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(_timeRemaining == 0) {
          _timeRemaining = 30;
          otpCodeString = otpService.generateOtp();
        } else {
          _timeRemaining--;
        }
      });
    });
  }

  @override 
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = GoogleFonts.inter;
    return ListTile(
      onTap: copyOtpToClipboard,
      onLongPress: deleteAuth,
      isThreeLine: false,
      tileColor: const Color.fromARGB(255, 1, 22, 40),
      
      leading:
        Icon(
          Icons.cloud_done,
          color: Colors.white,
        ),
      title: 
        Row( 
          children: [
            Text(
              otpCodeString,
              style: GoogleFonts.inter( 
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
              alignment: Alignment.topRight,
              onPressed: copyOtpToClipboard, 
              icon: Icon(Icons.content_copy, size: 12, color: Colors.grey,)
            )
          ]
        ),
        subtitle: 
          Text( 
            "Google",
            style: GoogleFonts.inter( 
              color: Colors.grey,
              fontSize: 14
            ),
          ),
        trailing: 
        Padding(
          padding: EdgeInsets.all(0),
          child: 
          OtpCountDown(
            duration: 30, 
            controller: _countdownController, 
            onComplete: () {
              _countdownController.restart();
            }
          ),
        )
          
        //rgb(3 13 64)
    );
  }
}

class OtpCountDown extends StatelessWidget {
  final CountDownController controller;
  final int duration;
  final VoidCallback onComplete;
  final initialDuration = 29;
  const OtpCountDown(
    {
      super.key,
      required this.duration,
      required this.controller,
      required this.onComplete,
    }
  );

  @override
  Widget build(BuildContext context) {
    return 
    CircularCountDownTimer(
      width: 42, 
      height: 42, 
      duration: duration,
      initialDuration: 29,
      isReverse: true,
      autoStart: true,
      fillColor: const Color.fromARGB(38, 60, 118, 255), 
      ringColor: Colors.lightBlueAccent,
      textStyle: GoogleFonts.inter( 
        color: Colors.white
      ),
      controller: controller,
      onComplete: onComplete,
    );
  }
}
