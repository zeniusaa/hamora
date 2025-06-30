part of 'models.dart';

class Review {
  final String id;
  final String movieTitle;
  final String reviewer;
  final String review;
  final double rating;

  Review({
    required this.id,
    required this.movieTitle,
    required this.reviewer,
    required this.review,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      movieTitle: json['movieTitle'],
      reviewer: json['reviewer'],
      review: json['review'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'movieTitle': movieTitle,
        'reviewer': reviewer,
        'review': review,
        'rating': rating,
      };
}
