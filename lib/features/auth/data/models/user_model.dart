class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      fullName: map['full_name'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'full_name': fullName, 'role': role};
  }
}
