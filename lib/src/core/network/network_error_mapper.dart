import 'dart:io';

import 'package:dio/dio.dart';

/// Centralized mapper to convert low-level network errors
/// into user-friendly, localized messages.
class NetworkErrorMapper {
  static String toMessage(Object error) {
    // Dio-specific handling
    if (error is DioException) {
      // Underlying socket error or clearly a connection issue
      if (_isNoConnection(error)) {
        return 'Нет подключение к интернету';
      }

      // If server returned a body with a human-readable message
      final data = error.response?.data;
      if (data is Map && data['detail'] is String) {
        return data['detail'] as String;
      }
      if (data != null) {
        return data.toString();
      }

      return error.message ?? 'Ошибка сети';
    }

    // Pure Dart socket issues
    if (error is SocketException) {
      return 'Нет подключение к интернету';
    }

    // Fallback
    return error.toString();
  }

  static bool _isNoConnection(DioException e) {
    // Newer Dio exposes connection-related types explicitly
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return true;
    }

    // Older or wrapped cases
    if (e.type == DioExceptionType.unknown && e.error is SocketException) {
      return true;
    }

    // Heuristic: common message from DNS failures
    final msg = (e.message ?? '').toLowerCase();
    if (msg.contains('failed host lookup') ||
        msg.contains('network is unreachable') ||
        msg.contains('connection refused') ||
        msg.contains('no address associated with hostname')) {
      return true;
    }

    return false;
  }
}
