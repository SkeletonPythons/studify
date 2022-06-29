class Event {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String id;
  final bool isAllDay;

  Event({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.isAllDay = false,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  Event.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'],
        startDate = map['startDate'],
        endDate = map['endDate'],
        location = map['location'],
        id = map['id'],
        isAllDay = map['isAllDay'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'id': id,
      'isAllDay': isAllDay,
    };
  }
}
