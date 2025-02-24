import 'dart:convert';

import 'package:firefly_user/models/building.dart';
import 'package:http/http.dart' as http;
import './routes.dart' as routes;

Future<Building> getBuildingById(int buildingId) async {
  final response = await http.get(
    Uri.parse("${routes.getBuildingById}/$buildingId"),
  );

  print(response.statusCode);

  if (response.statusCode != 200) {
    throw Exception('${response.statusCode}: ${response.body}');
  } else {
    Building building =
        Building.fromJson(jsonDecode(response.body)['building']);
    return building;
  }
}
