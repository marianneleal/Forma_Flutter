class Habit {
  int? id;
  String name;
  int color;
  DateTime? dueDate;

  Habit({
    this.id,
    required this.name,
    required this.color,
    this.dueDate,
  });

  factory Habit.fromMap(Map<String, dynamic> json) => Habit(
        id: json['id'],
        name: json['name'],
        color: json['color'],
        dueDate: json['dueDate'] != null
            ? DateTime.parse(json['dueDate'] as String)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'color': color,
        'dueDate': dueDate?.toIso8601String(),
      };
}
