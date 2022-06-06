class AppUser {
  AppUser({
    required this.uid,
    required this.first,
    required this.email,
    this.last,
    this.phoneNumber,
    this.photoUrl,
    this.settings,
  });

  String uid;
  String first;
  String? last;
  String email;
  String? photoUrl;
  String? phoneNumber;
  Map<String, bool>? settings = {
    // TODO: Add settings that will be synced to the database.
    'isVerified': false,
  };
  Map<String, dynamic> stats = {
    /// Statistics that will be synced to the database.
    'cardsCreated': 0,
    'testsTaken': 0,
    'numCorrect': 0,
    'numIncorrect': 0,
    'numSkipped': 0,
    'daysStudied': 0,
    'hoursStudied': 0,
    'minutesStudied': 0,
    'tasksCreated': 0,
    'tasksCompleted': 0,
    'tasksSkipped': 0,
    'tasksIncomplete': 0,
    'eventsCreated': 0,
    'eventsCompleted': 0,
  };

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'first': first,
        'last': last,
        'email': email,
        'photoUrl': photoUrl,
        'phoneNumber': phoneNumber,
        'settings': settings,
        'stats': stats,
      };

  AppUser.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        first = json['first'],
        last = json['last'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        phoneNumber = json['phoneNumber'],
        settings = json['settings'],
        stats = json['stats'];
}
