import 'dart:convert';

import 'package:firefly_user/models/user.dart';
import 'package:firefly_user/utils/user_not_found_exception.dart';
import 'package:http/http.dart' as http;
import './routes.dart' as routes;

Future<User> registerUser(String firebaseToken, String phoneNumber, String name,
    String city, int age, String gender, String medicalConditions) async {
  Map<String, dynamic> body = {
    'phoneNumber': phoneNumber,
    'name': name,
    'city': city,
    'age': age,
    'gender': gender,
    'medicalConditions': medicalConditions
  };
  final response = await http.post(Uri.parse(routes.registerUser),
      headers: {
        'authorization': firebaseToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body));
  print(body);
  print(response.statusCode);
  if (response.statusCode != 200) {
    print(response.body);
    throw Exception('${response.statusCode}: ${response.body}');
  } else {
    User user = User.fromJson(jsonDecode(response.body)['user']);
    return user;
  }
}

Future<User> getUser(String firebaseToken) async {
  final response = await http.get(Uri.parse(routes.getUser),
      headers: {"authorization": firebaseToken});

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 404) {
    throw UserNotFoundExcpetion('User not found');
  } else if (response.statusCode == 200) {
    User user = User.fromJson(jsonDecode(response.body)['user']);
    return user;
  } else {
    throw Exception('Server Error');
  }
}

Future<void> updateFcmToken(String firebaseToken, String fcmToken) async {
  final response = await http.patch(Uri.parse(routes.updateUser),
      headers: {
        'authorization': firebaseToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fcmToken': fcmToken}));
  print(response.statusCode);
  if (response.statusCode != 200) {
    throw Exception('${response.statusCode}: ${response.body}');
  }
}

Future<void> confirmIncident(String firebaseToken, int incidentId) async {
  final response = await http.post(Uri.parse(routes.confirmIncident), headers: {
    'authorization': firebaseToken,
    'Content-Type': 'application/json',
  }, body: {
    'incidentId': incidentId,
  });
  print(response.statusCode);

  if (response.statusCode != 200) {
    throw Exception('${response.statusCode}: ${response.body}');
  }
}
