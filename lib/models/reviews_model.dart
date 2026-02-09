class Review {
  final String id;
  final String username;
  final String text;
  final double rating;

  Review({
    required this.id,
    required this.username,
    required this.text,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String ?? '',
      username: json['username'] as String ?? '',
      text: json['text'] as String ?? '',
      rating: (json['rating'] as num).toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'text': text,
      'rating': rating,
    };
  }
}
