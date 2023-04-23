class Task {
  int? id;
  String name;
  bool isCompleted;
  int habitId;

  Task(
      {this.id,
      required this.name,
      this.isCompleted = false,
      this.habitId = -1});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      isCompleted: map['isCompleted'] == 1,
      habitId: map['habitId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted ? 1 : 0,
      'habitId': habitId,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<Task> tasks) {
    List<Map<String, dynamic>> mapList = [];
    for (Task task in tasks) {
      mapList.add(task.toMap());
    }
    return mapList;
  }
}
