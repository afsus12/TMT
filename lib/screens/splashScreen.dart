import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/menucontroller.dart';
import 'package:tmt_mobile/controllers/myorganisationcontroller.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/screens/MenuScreen.dart';
import 'package:tmt_mobile/screens/MyOrganisationScreen.dart';
import 'package:tmt_mobile/screens/landingScreen.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/utils/userServices.dart';
import 'package:tmt_mobile/utils/utils.dart';
import 'package:tmt_mobile/widgets/big_text.dart';
import 'package:video_player/video_player.dart';

import 'HomePage.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  late UserServices _services;
  bool _visible = false;

  @override
  void initState() {
    _services = new UserServices();
    super.initState();

    _controller = VideoPlayerController.asset(
      "assets/video/splash_video.mp4",
    );
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });

   checkConnectionAndNavigate();
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }
Future<void> checkConnectionAndNavigate() async {
  // Wait for 5 seconds before executing the connection check
  await Future.delayed(Duration(seconds: 5));

  // Check the connection status
  var connected = await _services.connected();
  print(connected);

  if (connected == 1) {
    // User is connected with a valid organization
    await Get.putAsync<Menucontroller>(() async => Menucontroller(),
        permanent: true);
    Get.offAll(MenuScreen());
  } else if (connected == 2) {
    // User is connected but lacks a valid organization
    await Get.putAsync<Menucontroller>(() async => Menucontroller(),
        permanent: true);
    Menucontroller menuController = Get.find<Menucontroller>();
    menuController.screenindex.value = 1;

    // Transition to the Menu Screen
    Get.offAll(MenuScreen());
  } else {
    // Display an error message if not connected
    _showConnectionError();
  }
}

void _showConnectionError() {
  Get.snackbar(
    '',
    '',
    titleText: BigText(
      text: "Oops! It seems like you've lost connection to the server",
      size: 18,
      color: Colors.green,
    ),
    messageText: Text(
      "Consider logging in again to re-establish your connection.",
      style: TextStyle(
        fontSize: 17,
      ),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: MyColors.BordersGrey.withOpacity(0.4),
    duration: const Duration(seconds: 3), // Increased duration for visibility
    overlayBlur: 0.7,
  );
  
  // Transition to the Landing Screen
  Get.offAll(LandingScreen());
}

  _getVideoBackground(globalController) {
    return AspectRatio(
      aspectRatio:
          globalController.devType.value == "tablet" ? 10 / 4 : 16 / 12,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 1000),
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  _getBackgroundColor() {
    return Container(
      color: Colors.white.withAlpha(180),
    );
  }

  _getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GlobalController());

    GlobalController globalController = Get.find<GlobalController>();
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(globalController),
          ],
        ),
      ),
    );
  }
}
