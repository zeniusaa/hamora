part of 'services.dart';


class ReviewService {
  static const String baseUrl = 'http://192.168.1.6:3000/ratings/'; // atau ganti dengan IP/public API kamu

  static Future<List<Review>> fetchReviews() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  static Future<Review> postReview(Review review) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(review.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final data = responseData['data'];

      return Review(
        id: data['_id'],
        movieTitle: data['movieTitle'],
        reviewer: data['reviewer'],
        review: data['review'],
        rating: (data['rating'] as num).toDouble(),
      );
    } else {
      throw Exception('Gagal mengirim review');
    }
  }


  static Future<void> deleteReview(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
