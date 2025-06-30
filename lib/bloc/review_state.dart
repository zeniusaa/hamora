// review_state.dart
part of 'review_bloc.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;

  ReviewLoaded(this.reviews);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}