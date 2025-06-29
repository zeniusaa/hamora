part of 'models.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  User(
    this.id,
    this.email, {
    this.name,
  });

  User copyWith({String? name, int? balance}) =>
      User(this.id, this.email,
          name: name ?? this.name);

  @override
  String toString() {
    return "[$id] - ${name ?? 'Unknown'}, $email";
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
      ];
}
