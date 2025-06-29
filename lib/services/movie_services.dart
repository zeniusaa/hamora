part of 'services.dart';

class MovieServices {
  static Future<List<Movie>> getMovies(String? genreId) async {
    final url =
        "${baseUrl}discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false${genreId != null ? '&with_genres=$genreId' : ''}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print("Error loading movies: ${response.statusCode}");
      return [];
    }

    final data = json.decode(response.body);
    final List results = data['results'];

    return results.map((e) => Movie.fromJson(e)).toList();
  }

  static Future<MovieDetail> getDetails(Movie? movie,
      {int? movieID, http.Client? client}) async {
    final id = movieID ?? movie?.id;
    final url = "${baseUrl}movie/$id?api_key=$apiKey&language=en-US";

    client ??= http.Client();

    final response = await client.get(Uri.parse(url));
    final data = json.decode(response.body);

    final genres = data['genres'];
    String language = _mapLanguageCode(data['original_language']);

    return MovieDetail(
      movieID != null ? Movie.fromJson(data) : (movie ?? Movie.fromJson(data)),
      language: language,
      genres: genres.map<String>((e) => e['name'].toString()).toList(),
    );
  }

  static Future<List<Credit>> getCredits(int movieID) async {
    final url = "${baseUrl}movie/$movieID/credits?api_key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    return (data['cast'] as List)
        .map((e) => Credit(
              name: e['name'],
              profilePath: e['profile_path'],
            ))
        .take(8)
        .toList();
  }

  static String _mapLanguageCode(String code) {
    switch (code) {
      case 'ja':
        return 'Japanese';
      case 'id':
        return 'Indonesian';
      case 'ko':
        return 'Korean';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }
}