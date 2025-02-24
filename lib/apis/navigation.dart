import 'package:http/http.dart' as http;

Future<void> requestRouting(int incidentId, String userId,
    {String? mode}) async {
  final response = await http.get(
    Uri.parse(
        "https://sih-nav.onrender.com/route_user?incident_id=${incidentId}&user_id=${userId}${mode != null ? "&mode=${mode}" : ""}"),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  print("Nav response:");
  print(response.statusCode);
  if (response.statusCode != 200) {
    throw Exception('${response.statusCode}: ${response.body}');
  }
}
