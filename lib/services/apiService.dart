import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://dummyjson.com";
  // ---------------------------
  // 🔹 Generic GET Request
  // ---------------------------
  static Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("GET Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("GET Exception: $e");
    }
  }

  // ---------------------------
  // 🔹 Generic POST Request
  // ---------------------------
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl$endpoint");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("POST Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("POST Exception: $e");
    }
  }

  // -------------------------------------------------------
  //   🔽 Example Specific API Functions  (add all here)
  // -------------------------------------------------------

  /// Get list of categories (perfect for dropdown)
  static Future<List<String>> getCategories() async {
  final response = await getRequest("/products/categories");

  return (response as List)
      .map((e) => e["name"].toString())
      .toList();
}


  /// Example: Create a new flag or report
  static Future<dynamic> submitFlag(String camName, String reason) async {
    return await postRequest("/posts/add", {
      "title": camName,
      "body": reason,
      "userId": 1
    });
  }
}
