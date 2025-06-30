part of 'pages.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil firebaseUser dari StreamProvider
    final auth.User? firebaseUser = Provider.of<auth.User?>(context);

    // Cek apakah User null atau tidak
    if (firebaseUser == null) {
      if (!(prevPageEvent is GoToSplashPage)) {
        prevPageEvent = GoToSplashPage();
        context.read<PageBloc>().add(prevPageEvent!);
      }
    } else {
      if (!(prevPageEvent is GoToMainPage)) {
        context.read<UserBloc>().add(LoadUser(firebaseUser.uid));

        prevPageEvent = GoToMainPage();
        context.read<PageBloc>().add(prevPageEvent!);
      }
    }

    return BlocBuilder<PageBloc, PageState>(
      builder: (_, pageState) {
        if (pageState is OnSplashPage) {
          return SplashPage();
        } else if (pageState is OnLoginPage) {
          return SignInPage();
        } else if (pageState is OnMainPage) {
          return MainPage();
        } else if (pageState is OnRegistrationPage) {
          return SignUpPage(pageState.registrasionData);
        } else if (pageState is OnAccountConfirmationPage) {
          return AccountConfirmationPage(pageState.registrationData);
        } else if (pageState is OnMovieDetailPage) {
          return BlocProvider(
            create: (_) => ReviewBloc()..add(LoadReviews()),
            child: MovieDetailPage(pageState.movie),
          );
        } else if (pageState is OnProfilePage) {
          return ProfilePage();
        } else if (pageState is OnEditProfilePage) {
          return EditProfilePage(pageState.user);
        } else {
          return Container();
        }
      },
    );
  }
}
