
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = 'http://localhost:5050/'; // order api base url
final tokenUrl = Uri.parse('${baseUrl}api/v1/webpubsub/token');
final groupUrl = Uri.parse('${baseUrl}api/v1/webpubsub/group');

Future<String> getToken() async {
  try {
    final response = await http.get(
      tokenUrl
    );

    if (response.statusCode == 200) {
      print('Post request successful!');
      final responseData = jsonDecode(response.body);
      print(responseData);

      return responseData["responseBody"]["objectVal"];
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }

  return "";
}

Future<void> addToGroup(
  String connectionId,
  String groupName
) async {
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'ConnectionId': connectionId,
    'GroupName': groupName
  });

  print(body);

  try {
    final response = await http.post(
      groupUrl,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Post request successful!');
      final responseData = jsonDecode(response.body);
      print(responseData);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }
}
