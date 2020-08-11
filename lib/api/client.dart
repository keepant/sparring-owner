import 'package:dio/dio.dart';
import 'package:sparring_owner/api/http.dart' as httpClient;
import 'package:sparring_owner/models/booking_payment_status.dart';

class FetchException implements Exception {
  final DioError _error;
  final String _message;

  FetchException([this._error, this._message]);

  String toString() {
    return "Exception: $_message.\n${_error.message}";
  }
}

Future<BookingPaymentStatus> bookingPaymentStatus(String orderID) async {
  try {
    Response response = await httpClient.bookingsPaymentStatus(orderID);
    return BookingPaymentStatus.fromJson(response.data);
  } on DioError catch (err) {
    throw FetchException(err, 'unable to load payment info');
  }
}
