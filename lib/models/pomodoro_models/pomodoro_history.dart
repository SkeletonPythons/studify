

class PomodoroHistory {
  DateTime dateTime;
  int timeStudied;
  int timeRested;
  int cycles;
  String id;

  PomodoroHistory({
    required this.dateTime,
    required this.timeStudied,
    required this.timeRested,
    required this.cycles,

}): id = dateTime.millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
    'dateTime': dateTime.millisecondsSinceEpoch,
    'timeStudied': timeStudied,
    'timeRested': timeRested,
    'cycles': cycles,
  };

  PomodoroHistory.fromJson(Map<String,dynamic> json)
  : dateTime = DateTime.fromMicrosecondsSinceEpoch(json['dateTime']),
  timeStudied = json['timeStudied'],
  timeRested = json['timeRested'],
  cycles = json['cycles'],
  id = json['id'];

  @override
  String toString() {
    return "\n\ndateTime:${dateTime.toIso8601String()},"
        "\n timeStudied: ${timeStudied.toString()},"
        " \n timeRested: ${timeRested.toString()}, "
        "\n cycles: ${cycles.toString()}, "
        "\n,\n";

  }


}