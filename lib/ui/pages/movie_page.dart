part of 'pages.dart';

class MoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // Note: Header
        _buildHeader(context),

        // Note: Now Playing
        _buildSectionTitle("Now Playing"),
        _buildNowPlaying(),

        // Note: Browse Movie
        _buildSectionTitle("Browse Movie"),
        _buildBrowseMovie(context),

        // Note: Coming Soon
        _buildSectionTitle("Coming Soon"),
        _buildComingSoon(),

        SizedBox(height: 100),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: accentColor1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 30),
      child: BlocBuilder<UserBloc, UserState>(builder: (_, userState) {
        if (userState is UserLoaded) {
          return Row(
            children: <Widget>[
              _buildUserInfo(userState.user, context),
            ],
          );
        } else {
          return SpinKitFadingCircle(
            color: accentColor2,
            size: 50,
          );
        }
      }),
    );
  }

  Widget _buildUserInfo(User user, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width - 2 * defaultMargin,
          child: GestureDetector(
            onTap: () {
            context.read<PageBloc>().add(GoToProfilePage());
            },
            child: Text(            
            user.name ?? 'No Name',
            style: whiteTextFont.copyWith(fontSize: 18),
            maxLines: 1,
            overflow: TextOverflow.clip,
            )
          ),
        ),
      ],
    );
  }
  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(defaultMargin, 30, defaultMargin, 12),
      child: Text(
        title,
        style: blackTextFont.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNowPlaying() {
    return SizedBox(
      height: 140,
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (_, movieState) {
          if (movieState is MovieLoaded) {
            List<Movie> movies = movieState.movies.sublist(0, 10);

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (_, index) => Container(
                margin: EdgeInsets.only(
                  left: (index == 0) ? defaultMargin : 0,
                  right: (index == movies.length - 1) ? defaultMargin : 16,
                ),
                child: MovieCard(
                  movies[index],
                  onTap: (BuildContext context) {
                    context
                        .read<PageBloc>()
                        .add(GoToMovieDetailPage(movies[index]));
                  },
                ),
              ),
            );
          } else {
            return SpinKitFadingCircle(color: mainColor, size: 50);
          }
        },
      ),
    );
  }

  Widget _buildBrowseMovie(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BrowseButton("Action", "28"),
          BrowseButton("War", "10752"),
          BrowseButton("Music", "10402"),
          BrowseButton("Crime", "80"),
        ],
      ),
    );
  }

  Widget _buildComingSoon() {
    return SizedBox(
      height: 160,
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (_, movieState) {
          if (movieState is MovieLoaded) {
            List<Movie> movies = movieState.movies.sublist(10);

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (_, index) => Container(
                margin: EdgeInsets.only(
                  left: (index == 0) ? defaultMargin : 0,
                  right: (index == movies.length - 1) ? defaultMargin : 16,
                ),
                child: ComingSoonCard(
                  movies[index],
                  onTap: () {},
                ),
              ),
            );
          } else {
            return SpinKitFadingCircle(color: mainColor, size: 50);
          }
        },
      ),
    );
  }

}
