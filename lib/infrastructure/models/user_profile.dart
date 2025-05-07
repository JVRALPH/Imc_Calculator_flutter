class UserProfile {
  final double age;
  final double weight;
  final double height;
  final String? gender;
  final String? weightUnit;
  final String? heightUnit;

  UserProfile({
    required this.age,
    required this.weight,
    required this.height,
    this.gender,
    this.weightUnit,
    this.heightUnit,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'weight': weight,
    'height': height,
    'gender': gender,
    'weightUnit': weightUnit,
    'heightUnit': heightUnit,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    age: json['age'] as double,
    weight: json['weight'] as double,
    height: json['height'] as double,
    gender: json['gender'] as String?,
    weightUnit: json['weightUnit'] as String?,
    heightUnit: json['heightUnit'] as String?,
  );
}
