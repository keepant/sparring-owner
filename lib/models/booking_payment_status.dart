import 'package:json_annotation/json_annotation.dart';

part 'booking_payment_status.g.dart';

@JsonSerializable()
class BookingPaymentStatus {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'payment_type')
  final String paymentType;

  @JsonKey(name: 'transaction_status')
  final String transactionStatus;

  @JsonKey(name: 'transaction_id')
  final String transactionId;

  @JsonKey(name: 'status_message')
  final String statusMessage;

  @JsonKey(name: 'settlement_time')
  final String settlementTime;

  @JsonKey(name: 'transaction_time')
  final String transactionTime;

  @JsonKey(name: 'gross_amount')
  final String grossAmount;

  BookingPaymentStatus({
    this.orderId,
    this.paymentType,
    this.transactionId,
    this.transactionStatus,
    this.transactionTime,
    this.grossAmount,
    this.settlementTime,
    this.statusMessage,
  });

  factory BookingPaymentStatus.fromJson(Map<String, dynamic> json) {
    return _$BookingPaymentStatusFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$BookingPaymentStatusToJson(this);
  }
}
