class User {
  final String id;
  final String? name;
  final int? age;
  final String? medicalConditions;
  final String? gender;
  final String? fcmToken;

  User({
    required this.id,
    this.name,
    this.age,
    this.medicalConditions,
    this.gender,
    this.fcmToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nam'],
      age: json['age'],
      medicalConditions: json['medicalConditions'],
      gender: json['gender'],
      fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'medicalConditions': medicalConditions,
      //'gender': gender,
      'fcmKey': fcmToken,
    };
  }
}
