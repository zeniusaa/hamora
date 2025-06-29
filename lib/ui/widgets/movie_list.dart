part of 'widgets.dart';

class MovieList extends StatelessWidget {
  final Movie movie;
  final Function(BuildContext) onTap;

  MovieList(this.movie, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    String imageUrl = (movie.posterPath.isNotEmpty)
        ? imagesBaseUrl + "w342" + movie.posterPath
        : 'https://via.placeholder.com/100x150?text=No+Image';

    return GestureDetector(
      onTap: () => onTap(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster (kiri)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey,
                  child: Icon(Icons.broken_image, color: Colors.white),
                ),
              ),
            ),

            SizedBox(width: 12),

            // Info movie (kanan)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: blackTextFont.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  RatingStars(voteAverage: movie.voteAverage),
                  SizedBox(height: 12),
                  Text(
                    movie.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: greyTextFont.copyWith(fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
