import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class RouterOsRestClient {
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useSsl;
  late final Dio _dio;

  RouterOsRestClient({
    required this.host,
    this.port = 80,
    required this.username,
    required this.password,
    this.useSsl = false,
  }) {
    final scheme = useSsl ? 'https' : 'http';
    final baseUrl = '$scheme://$host:$port';
    final authHeader = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiConstants.readTimeoutMs),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeoutMs),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  /// Generic GET request
  Future<List<Map<String, dynamic>>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(
            (response.data as List).map((e) => Map<String, dynamic>.from(e as Map)),
          );
        } else if (response.data is Map) {
          return [Map<String, dynamic>.from(response.data as Map)];
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Generic POST request (create)
  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  /// Generic PUT request (update or create)
  Future<Response> put(String path, Map<String, dynamic> data) async {
    return await _dio.put(path, data: data);
  }

  /// Generic PATCH request (update)
  Future<Response> patch(String path, Map<String, dynamic> data) async {
    return await _dio.patch(path, data: data);
  }

  /// Generic DELETE request
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  /// Test REST connection
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get(ApiConstants.systemResourcePath);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
