class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.isVerified,
  }) : db = 'users/$uid';

  String uid;
  String name;
  String email;
  String? photoUrl;
  String? phoneNumber;
  String db;
  bool? isVerified = false;
  Map<String, dynamic> settings = {
    // TODO: Add settings that will be synced to the database.
  };

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'phoneNumber': phoneNumber,
        'isVerified': isVerified,
        'settings': settings,
      };
}
