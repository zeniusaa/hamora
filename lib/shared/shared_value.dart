part of 'shared.dart';

// API Configuration
const String apiKey = '2deedfb262ee376001a53d001b1e17ce';
const String baseUrl = 'https://api.themoviedb.org/3/';
const String imagesBaseUrl = 'https://image.tmdb.org/t/p/';

// Endpoints
String getNowPlayingUrl({int page = 1}) =>
    '${baseUrl}movie/now_playing?api_key=$apiKey&language=en-US&page=$page';

String getComingSoonUrl({int page = 1}) =>
    '${baseUrl}movie/upcoming?api_key=$apiKey&language=en-US&page=$page';

String getPopularMoviesUrl({int page = 1}) =>
    '${baseUrl}movie/popular?api_key=$apiKey&language=en-US&page=$page';

String getMovieDetailUrl(int movieId) =>
    '${baseUrl}movie/$movieId?api_key=$apiKey&language=en-US';

String getGenresUrl() =>
    '${baseUrl}genre/movie/list?api_key=$apiKey&language=en-US';

// Global Variables
PageEvent? prevPageEvent;
late File imageFileToUpload;
