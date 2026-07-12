class BookingModel {
  final String? id;
  final String userId;
  final String courtId;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final int totalPrice;
  final String status;
  final String? courtName;
  final String? paymentProof;

  BookingModel({
    this.id,
    required this.userId,
    required this.courtId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    this.status = 'Pending',
    this.courtName,
    this.paymentProof,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['user_id'],
      courtId: json['court_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalPrice: json['total_price'],
      status: json['status'],
      courtName: json['courts']?['name'],
      paymentProof: json['payment_proof'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'court_id': courtId,
      'booking_date': bookingDate.toIso8601String().split('T').first,
      'start_time': startTime,
      'end_time': endTime,
      'total_price': totalPrice,
      'status': status,
      'payment_proof': paymentProof,
    };
  }
}
