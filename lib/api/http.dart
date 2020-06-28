import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'dart:convert';

final baseUrl = "https://api.sandbox.midtrans.com/v2";
final String credential = "SB-Mid-server-SuVRY5V50VYPx6a6X57F5wUu:";
final token = base64.encode(utf8.encode(credential));

Dio dioClient() {
  BaseOptions options = new BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Basic '+token,
    },
  );

  Dio dio = new Dio(options);
  dio.interceptors
      .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);

  return dio;
}

Dio httpClient = dioClient();

Future<Response> bookingsPaymentStatus(String orderID) {
  return httpClient.get(
    "/"+orderID+"/status",
  );
}
