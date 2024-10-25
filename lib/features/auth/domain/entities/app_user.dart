class AppUser {
  final String id;
  final String email;
  final String name;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
  });

  //Converts app user -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'email': email,
      'name': name,
    };
  }

  //Convert json -> appUser
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
        id: jsonUser['uid'], email: jsonUser['email'], name: jsonUser['name']);
  }
}
