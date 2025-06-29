import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hamora/models/models.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(OnInitialPage()) {
    on<GoToSplashPage>((event, emit) {
      emit(OnSplashPage());
    });
    on<GoToLoginPage>((event, emit) {
      emit(OnLoginPage());
    });
    on<GoToMainPage>((event, emit) {
      emit(OnMainPage());
    });
    on<GoToRegistrasionPage>((event, emit) {
      emit(OnRegistrationPage(event.registrasionData));
    });
    on<GoToAccountConfirmationPage>((event, emit) {
      emit(OnAccountConfirmationPage(event.registrasionData));
    });
    on<GoToMovieDetailPage>((event, emit) {
      emit(OnMovieDetailPage(event.movie));
    });
    on<GoToProfilePage>((event, emit) {
      emit(OnProfilePage());
    });
    on<GoToEditProfilePage>((event, emit) {
      emit(OnEditProfilePage(event.user));
    });
  }
}
