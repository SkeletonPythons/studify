class AppUser {
  AppUser({
    required this.uid,
    this.name,
    required this.email,
    this.photoUrl,
    this.settings,
  });

  String uid;
  String? name;
  String email;
  String? photoUrl;
  Map<String, bool>? settings = {
    'isVerified': false,
    'isNewUser': true,
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
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'settings': settings,
        'stats': stats,
      };

  AppUser.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        settings = json['settings'],
        stats = json['stats'];
}
