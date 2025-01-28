import 'dart:io';

import 'package:flutter/widgets.dart';
// tmt-mapi-dev-wap-01-fubec3e0dyffa8e8.northeurope-01.azurewebsites.net for hosted
final String apiUrl = "https://10.0.2.2:7052/"; //for emulator use http://10.0.2.2:7052  || for physical device with USB debug localhost or 127.0.0.1  SAME NETWORK FOR PHONE AND PC
final String QuerryUrl = "10.0.2.2:7052/";//for emulator use http://10.0.2.2:7052  || for physical device with USB debug localhost or 127.0.0.1  SAME NETWORK FOR PHONE AND PC
                      // without usb debug you can run app using the  local ipv4 Addresse like this one 192.168.87.47:7052 
                                                                         
String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
