import 'dart:convert';

import 'package:firefly_user/models/node.dart';
import 'package:http/http.dart' as http;
import './routes.dart' as routes;

Future<Map<int, Node>> getAllNodesForBuilding(
    String firebaseToken, int buildingId) async {
  final response = await http.get(
      Uri.parse(routes.getAllNodesForBuilding(buildingId)),
      headers: {"authorization": firebaseToken});

  print(routes.getAllNodesForBuilding(buildingId));
  print(response.statusCode);
  print(response.body);

  final decodedResponse = jsonDecode(response.body);
  if (response.statusCode != 200) {
    throw Exception('${response.statusCode}: ${response.body}');
  } else {
    Map<int, Node> nodes = {};
    for (var node in decodedResponse['data']) {
      nodes.putIfAbsent(node['id'], () => Node.fromJson(node));
    }
    return nodes;
  }
}
