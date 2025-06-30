// review_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hamora/models/models.dart';
import 'package:hamora/services/services.dart';

part 'review_event.dart';
part 'review_state.dart';


class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<AddReview>(_onAddReview);
    on<DeleteReview>(_onDeleteReview);
  }

  Future<void> _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final reviews = await ReviewService.fetchReviews();
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError("Gagal memuat review: $e"));
    }
  }

  Future<void> _onAddReview(
    AddReview event,
    Emitter<ReviewState> emit,
  ) async {
    print("📤 Menambahkan review...");

    try {
      await ReviewService.postReview(event.review);
      print("✅ Review berhasil dikirim");
      add(LoadReviews());
    } catch (e) {
      print("❌ Gagal kirim review: $e");
      emit(ReviewError("Gagal menambahkan review: $e"));
    }
  }
  
  Future<void> _onDeleteReview(
    DeleteReview event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      await ReviewService.deleteReview(event.id);
      add(LoadReviews());
    } catch (e) {
      emit(ReviewError("Gagal menghapus review: $e"));
    }
  }

  
}
