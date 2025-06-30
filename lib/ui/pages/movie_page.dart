part of 'pages.dart';

class MoviePage extends StatefulWidget {
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final ScrollController _scrollController = ScrollController();
  int _loadedItems = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _loadedItems += 10;
            _isLoadingMore = false;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: <Widget>[
        _buildUserHeader(context),
        _buildSectionTitle("Recommended Films"),
        _buildRecommendedMovies(),

        _buildSectionTitle("Browse by Genre"),
        _buildGenreList(context),

        _buildSectionTitle("Coming Soon"),
        _buildComingSoonMovies(),

        _buildSectionTitle("All Movies"),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (_, movieState) {
            if (movieState is MovieLoaded) {
              return _buildAllMoviesList(movieState.movies);
            } else {
              return SpinKitFadingCircle(color: mainColor, size: 50);
            }
          },
        ),

        SizedBox(height: 100),
      ],
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: accentColor1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 30),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (_, userState) {
          if (userState is UserLoaded) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  context.read<PageBloc>().add(GoToProfilePage());
                },
                child: Text(
                  userState.user.name ?? 'No Name',
                  style: whiteTextFont.copyWith(fontSize: 28),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return SpinKitFadingCircle(
              color: accentColor2,
              size: 50,
            );
          }
        },
      ),
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

  Widget _buildRecommendedMovies() {
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

  Widget _buildGenreList(BuildContext context) {
    final genres = [
      {"name": "Action", "id": "28"},
      {"name": "Crime", "id": "80"},
      {"name": "Drama", "id": "18"},
      {"name": "Horror", "id": "27"},
      {"name": "Music", "id": "10402"},
      {"name": "War", "id": "10752"},
    ];

    return Container(
      height: 130,
      margin: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Container(
            margin: EdgeInsets.only(right: 12),
            child: BrowseButton(genre["name"]!, genre["id"]!),
          );
        },
      ),
    );
  }

  Widget _buildComingSoonMovies() {
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
                  onTap: (BuildContext context) {
                    context.read<PageBloc>().add(GoToMovieDetailPage(movies[index]));
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

  Widget _buildAllMoviesList(List<Movie> movies) {
    final displayedMovies =
        movies.length > _loadedItems ? movies.sublist(0, _loadedItems) : movies;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: displayedMovies.length,
          itemBuilder: (_, index) => Container(
            margin: EdgeInsets.fromLTRB(defaultMargin, 8, defaultMargin, 8),
            child: MovieList(
              displayedMovies[index],
              onTap: (BuildContext context) {
                context
                    .read<PageBloc>()
                    .add(GoToMovieDetailPage(displayedMovies[index]));
              },
            ),
          ),
        ),
        if (_loadedItems < movies.length)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
      ],
    );
  }
}
