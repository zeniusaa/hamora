// review_event.dart
part of 'review_bloc.dart';

abstract class ReviewEvent {}

class LoadReviews extends ReviewEvent {}

class AddReview extends ReviewEvent {
  final Review review;

  AddReview(this.review);
}

class DeleteReview extends ReviewEvent {
  final String id;

  DeleteReview(this.id);
}