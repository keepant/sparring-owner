// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_payment_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingPaymentStatus _$BookingPaymentStatusFromJson(Map<String, dynamic> json) {
  return BookingPaymentStatus(
    orderId: json['order_id'] as String,
    paymentType: json['payment_type'] as String,
    transactionId: json['transaction_id'] as String,
    transactionStatus: json['transaction_status'] as String,
    transactionTime: json['transaction_time'] as String,
    grossAmount: json['gross_amount'] as String,
    settlementTime: json['settlement_time'] as String,
    statusMessage: json['status_message'] as String,
  );
}

Map<String, dynamic> _$BookingPaymentStatusToJson(
        BookingPaymentStatus instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'payment_type': instance.paymentType,
      'transaction_status': instance.transactionStatus,
      'transaction_id': instance.transactionId,
      'status_message': instance.statusMessage,
      'settlement_time': instance.settlementTime,
      'transaction_time': instance.transactionTime,
      'gross_amount': instance.grossAmount,
    };
