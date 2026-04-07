class Booking {
  final int id;
  final int userId;
  final int arenaId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.arenaId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      arenaId: json['arena_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
    );
  }
}
