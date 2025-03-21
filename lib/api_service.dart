import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl =
      "https://book-management-backend-jydw.onrender.com";
  // ignore: unused_field
  static String? _token; // To store the authentication token

  // Set Token (After login/signup)
  static void setToken(String token) {
    _token = token;
  }

  // Signup
  static Future<Map<String, dynamic>?> signUp(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/users/signup');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Login
  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setToken(data['token']); // Store the token
      return data['token'];
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Fetch Firebase token
  static Future<String?> getFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? await user.getIdToken() : null;
  }

  // Fetch all books
  static Future<List<dynamic>> getBooks() async {
    final token = await getFirebaseToken();
    if (token == null) throw Exception("User not authenticated");

    final url = Uri.parse('$baseUrl/books/getbooks');
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Fetch book by ID
  static Future<Map<String, dynamic>?> getBookById(int id) async {
    final token = await getFirebaseToken();
    if (token == null) throw Exception("User not authenticated");

    final url = Uri.parse('$baseUrl/books/getbooks/$id');
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Create a new book
  static Future<Map<String, dynamic>?> createBook(
    String title,
    String author,
    String publishedDate,
    int pages,
    String language,
    String publisher,
  ) async {
    final token = await getFirebaseToken();
    if (token == null) throw Exception("User not authenticated");

    final url = Uri.parse('$baseUrl/books/createbooks');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "author": author,
        "publishedDate": publishedDate,
        "pages": pages,
        "language": language,
        "publisher": publisher,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Update a book
  static Future<String?> updateBook(
    int id,
    String title,
    String author,
    String publishedDate,
    int pages,
    String language,
    String publisher,
  ) async {
    final token = await getFirebaseToken();
    if (token == null) throw Exception("User not authenticated");

    final url = Uri.parse('$baseUrl/books/updatebooks/$id');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "author": author,
        "publishedDate": publishedDate,
        "pages": pages,
        "language": language,
        "publisher": publisher,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Delete a book
  static Future<String?> deleteBook(int id) async {
    final token = await getFirebaseToken();
    if (token == null) throw Exception("User not authenticated");

    final url = Uri.parse('$baseUrl/books/deletebooks/$id');
    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
