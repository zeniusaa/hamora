part of 'extensions.dart';

extension FirebaseUserExtension on auth.User {
  User convertToUser({
    String name = "No Name",
    List<String> selectedGenres = const [],
    String selectedLanguage = "English",
    int balance = 50000,
  }) =>
      User(
        uid,
        email ?? "",
        name: name,
      );

  Future<User> fromFireStore() async {
    return await UserServices.getUser(uid);
  }
}
