import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_mobile/models/imputation.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/utils/userPrefrences.dart';
import 'dart:convert';

import 'package:tmt_mobile/utils/utils.dart';

class UserServices {
  Future<http.Response> login(userLogin data) async {
  try {
    // Make the HTTP POST request
    final response = await http.post(
      Uri.parse('${apiUrl}login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': data.email,
        'password': data.password,
      }),
    );

    // Log the response and handle different status codes
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Login successful: ${response.body}');
    } else {
      print('Login failed: ${response.statusCode} - ${response.body}');
    }

    return response;
  } catch (e) {
    // Handle different types of exceptions
    if (e is SocketException) {
      print('Network Error: No internet connection. Details: $e');
      return http.Response('{"error": "No internet connection"}', 503);
    } else if (e is HttpException) {
      print('HTTP Error: Server issue. Details: $e');
      return http.Response('{"error": "HTTP exception occurred"}', 500);
    } else if (e is FormatException) {
      print('Data Error: Invalid JSON format. Details: $e');
      return http.Response('{"error": "Invalid JSON format"}', 400);
    } else {
      // Handle unexpected errors
      print('Unexpected Error: Something went wrong. Details: $e');
      return http.Response('{"error": "Unexpected error occurred"}', 500);
    }
  }
}

  Future<http.Response> sendValidationCode(String email) {
    return http.post(
      Uri.parse('${apiUrl}SendEmailValidation?email=${email}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> sendResetCode(String email) {
    return http.post(
      Uri.parse('${apiUrl}SendEmailReset?email=${email}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

 Future<http.Response> registration(userRegistration data) async {
  try {
    // Attempt to make the HTTP POST request
    final response = await http.post(
      Uri.parse('${apiUrl}register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': data.email,
        'firstname': data.firstname,
        'password': data.password,
        'lastname': data.lastname,
      }),
    );

    // Check for success
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Success: Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Error: Registration failed with status code ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    return response;
  } catch (e) {
    // Handle different error types
    if (e is SocketException) {
      print('Network Error: No internet connection. Details: $e');
      return http.Response('{"error": "No internet connection"}', 503);
    } else if (e is HttpException) {
      print('HTTP Error: Server issue. Details: $e');
      return http.Response('{"error": "HTTP exception occurred"}', 500);
    } else if (e is FormatException) {
      print('Data Error: Invalid JSON format. Details: $e');
      return http.Response('{"error": "Invalid JSON format"}', 400);
    } else {
      // Generic error logging
      print('Unexpected Error: Something went wrong. Details: $e');
      return http.Response('{"error": "Unexpected error occurred"}', 500);
    }
  }
}

  Future<http.Response> addTimesheet(
      int idPj, int idPl, int idPt, DateTime tsDay, double value) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.post(
      Uri.parse(
          '${apiUrl}AddTimeSheets?IdProjet=${idPj}&idProjetLot=${idPl}&idProjetTask=${idPt}&tsDay=${tsDay}&value=${value}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> deleteTimesheet(int id) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.delete(Uri.parse('${apiUrl}deleteTimeSheets?id=${id}'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        });
  }

  Future<http.Response> getAllOrgs(String email) async {
    return http.get(Uri.parse('${apiUrl}getalluserorg?email=${email}'),
        headers: {"Accept": "application/json"});
  }

  Future<http.Response> getOneOrg(String guid) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.get(Uri.parse('${apiUrl}getOneOrg?guid=${guid}'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
  }

  Future<http.Response> getProjects() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.get(Uri.parse('${apiUrl}getProjects'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
  }

  Future<http.Response> getRecentTimeSheets() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.get(Uri.parse('${apiUrl}getRecentTimeSheets'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
  }

  Future<http.Response> copyLastTimeSheet() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.get(Uri.parse('${apiUrl}copyLastTimeSheet'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
  }

  Future<http.Response> getProjectslots(int idprojet) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.get(Uri.parse('${apiUrl}getProjectlots?projectId=${idprojet}'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        });
  }

Future<http.Response> getProjectsTasks(int projectLot) async {
  final storage = FlutterSecureStorage();
  var token = await storage.read(key: "jwt");
  
  // Ensure token is not null before making a request
  if (token == null) {
    // Handle missing token scenario, perhaps notify the user
    return Future.error('User not authenticated.');
  }
  
  return http.get(
    Uri.parse('${apiUrl}getProjectTasks?projectlotid=${projectLot}'),
    headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
}

Future<int> connected() async {
  var response = await isAuthentifed();
  var validAccount = UserPrefrences.getCureentIsValid();
  var userEmail = UserPrefrences.getUserEmail();
  var org = UserPrefrences.getCureentOrg();
  
  print(response.body);
  print(userEmail);
  
  // Check the validity of the connection
  if (response.statusCode == 200 && validAccount==true && userEmail!.isNotEmpty) {
    return (org != null && org.isNotEmpty) ? 1 : 2;
  }

  // Return 0 if not connected
  return 0;
}

  Future<http.Response> isAuthentifed() async {
    
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    print(token);
    return http.get(Uri.parse('${apiUrl}authentified'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
  }

  Future<http.Response> getTimesheet(DateTime date) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "jwt");
    return http.get(Uri.parse('${apiUrl}getTimeSheets?date=${date}'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
  }

  Future<http.Response> changepassword(
      String email, String code, String password) {
    final uri = Uri.parse(
      '${apiUrl}ResetPassowrd?email=${email}&resetCode=${code}&password=${password}',
    );
    return http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> confirmation(String email, String code) {
    final queryparams = {
      'email': email,
      'registrationCode': code,
    };
    final uri = Uri.parse(
      '${apiUrl}registryconfirmation?email=${email}&registrationCode=${code}',
    );
    return http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
