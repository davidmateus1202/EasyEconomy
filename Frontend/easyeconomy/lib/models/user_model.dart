class UserModer {
  int? id;
  String? token;
  String? name;
  String? email, fisrt_name, last_name;
  String? imagen_profile;

  UserModer({
    this.id,
    this.name,
    this.email,
    this.fisrt_name,
    this.last_name,
    this.imagen_profile,
  });

  factory UserModer.fromJson(json) {
    return UserModer(
      id: json['id'],
      name: json['username'],
      email: json['email'],
      fisrt_name: json['first_name'],
      last_name: json['last_name'],
      imagen_profile: json["imagen_profile"],
    );
  }
}
