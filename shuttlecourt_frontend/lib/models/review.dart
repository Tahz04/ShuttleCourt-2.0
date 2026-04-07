class Review {
  final int id;
  final int userId;
  final int arenaId;
  final int rating;
  final String? comment;
  final String createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.arenaId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      arenaId: json['arena_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['createdAt'],
    );
  }
}
