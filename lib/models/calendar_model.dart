class Event {
  String title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? location;
  String id;
  bool isAllDay;

  Event({
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.location,
    this.isAllDay = false,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  Event.fromMap(Map<String, dynamic> map, this.id)
      : title = map['title'],
        description = map['description'],
        startDate = map['startDate'],
        endDate = map['endDate'],
        location = map['location'],
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
