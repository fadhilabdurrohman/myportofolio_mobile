import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/experience.dart';
import '../models/project.dart';

typedef JsonMap = Map<String, dynamic>;

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'HTTP $statusCode · $message';
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl/api/v1/$path');

  static const _timeout = Duration(seconds: 15);

  void close() => _client.close();

  void _check(http.Response response, int expected) {
    if (response.statusCode == expected) return;

    var message = 'Permintaan gagal.';
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map<String, dynamic> && body.isNotEmpty) {
        message = body.entries
            .map((entry) {
              final value = entry.value;
              final detail = value is List ? value.join(' ') : value.toString();
              return '${entry.key}: $detail';
            })
            .join('\n');
      }
    } on FormatException {
      // Sebagian kegagalan server mengembalikan HTML.
    }
    throw ApiException(response.statusCode, message);
  }

  Future<List<T>> _list<T>(String path, T Function(JsonMap) fromJson) async {
    final response = await _client
        .get(_uri(path), headers: {'Accept': 'application/json'})
        .timeout(_timeout);

    _check(response, 200);
    final rows = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return rows.map((row) => fromJson(row as JsonMap)).toList();
  }

  Future<http.Response> _post(String path, {JsonMap? body, String? token}) {
    return _client
        .post(
          _uri(path),
          headers: {
            'Accept': 'application/json',
            if (body != null) 'Content-Type': 'application/json; charset=utf-8',
            if (token != null) 'Authorization': 'Token $token',
          },
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(_timeout);
  }

  Future<List<Project>> getProjects() => _list('projects/', Project.fromJson);

  Future<List<Experience>> getExperiences() =>
      _list('experiences/', Experience.fromJson);

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _post(
      'projects/',
      body: project.toJson(),
      token: token,
    );
    _check(response, 201);
    return Project.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as JsonMap,
    );
  }

  Future<Experience> createExperience(
    Experience experience, {
    required String token,
  }) async {
    final response = await _post(
      'experiences/',
      body: experience.toJson(),
      token: token,
    );
    _check(response, 201);
    return Experience.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as JsonMap,
    );
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _post(
      'auth/token/',
      body: {'username': username, 'password': password},
    );
    _check(response, 200);
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as JsonMap;
    return data['token'] as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _post('auth/logout/', token: token);
    _check(response, 204);
  }
}
