import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';

part 'api_provider.g.dart';

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
} 