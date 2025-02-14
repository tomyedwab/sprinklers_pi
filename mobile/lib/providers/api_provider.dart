import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../models/system_state.dart';

part 'api_provider.g.dart';

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
}

@riverpod
class APIProvider extends _$APIProvider {
  final String baseUrl = 'http://localhost:8080';

  @override
  Future<void> build() async {}
} 