part of 'pages.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  MovieDetailPage(this.movie);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<PageBloc>(context).add(GoToMainPage());
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(color: accentColor1),
            SafeArea(child: Container(color: Colors.white)),
            ListView(
              children: <Widget>[
                _buildMovieDetailHeader(context),
                FutureBuilder(
                  future: MovieServices.getDetails(movie),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      MovieDetail? movieDetail = snapshot.data;
                      return Column(
                        children: <Widget>[
                          _buildMovieInfo(movie, movieDetail!),
                          _buildCastAndCrewSection(movie.id),
                          _buildStorylineSection(movie),
                          _buildReviewSection(context, movie),
                        ],
                      );
                    } else {
                      return Center(
                        child: SpinKitFadingCircle(color: accentColor3),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetailHeader(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 270,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                imagesBaseUrl + "w1280" + (movie.backdropPath ?? movie.posterPath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 271,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, 1),
              end: Alignment(0, 0.06),
              colors: [Colors.white, Colors.white.withOpacity(0)],
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: defaultMargin,
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<PageBloc>(context).add(GoToMainPage());
            },
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.04),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo(Movie movie, MovieDetail movieDetail) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 16, defaultMargin, 6),
          child: Text(
            movie.title,
            textAlign: TextAlign.center,
            style: blackTextFont.copyWith(fontSize: 24),
          ),
        ),
        Text(
          movieDetail.genresAndLanguage,
          style: greyTextFont.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 6),
        Text(
          movie.title,
          style: whiteTextFont.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCastAndCrewSection(int movieId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: defaultMargin, bottom: 12),
          child:
              Text("Cast & Crew", style: blackTextFont.copyWith(fontSize: 14)),
        ),
        FutureBuilder(
          future: MovieServices.getCredits(movieId),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              List<Credit>? credits = snapshot.data;
              return SizedBox(
                height: 115,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: credits?.length,
                  itemBuilder: (_, index) => Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? defaultMargin : 0,
                      right: index == credits!.length - 1 ? defaultMargin : 16,
                    ),
                    child: CreditCard(credits[index]),
                  ),
                ),
              );
            } else {
              return Center(
                child: SpinKitFadingCircle(color: accentColor1),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStorylineSection(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 24, defaultMargin, 8),
          child: Text("Storyline", style: blackTextFont),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 30),
          child: Text(
            movie.overview,
            style: greyTextFont.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection(BuildContext context, Movie movie) {
    final _controller = TextEditingController();
    double _currentRating = 3;
    String reviewerName = "Anonymous";

    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      reviewerName = userState.user.name ?? "Anonymous";
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(defaultMargin, 16, defaultMargin, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("User Reviews", style: blackTextFont.copyWith(fontSize: 16)),
          BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ReviewLoaded) {
                final movieReviews = state.reviews
                    .where((r) => r.movieTitle == movie.title)
                    .toList();

                return Column(
                  children: movieReviews.map((r) {
                    return ListTile(
                      title: Text(r.reviewer),
                      subtitle: Text(r.review),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          r.rating.toInt(),
                          (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Text("Belum ada review.");
              }
            },
          ),
          SizedBox(height: 20),
          Divider(),
          Text("Your Review", style: blackTextFont.copyWith(fontSize: 14)),
          SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Tell Everyone....",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Rating: ", style: blackTextFont),
              SizedBox(width: 10),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentRating = (index + 1).toDouble();
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: index < _currentRating ? Colors.amber : Colors.grey[400],
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final review = Review(
                id: '',
                movieTitle: movie.title,
                reviewer: reviewerName,
                review: _controller.text,
                rating: _currentRating,
              );
              BlocProvider.of<ReviewBloc>(context).add(AddReview(review));
              _controller.clear();
            },
            child: Text("Review"),
          ),
        ],
      ),
    );
  }
}
