
class Goal{
  final String goal_name;
  String? goal_id;

  Goal({required this.goal_name, this.goal_id});


  Map<String, dynamic> toJson() => {
    'goal_name': goal_name,
    'goal_id' : goal_id
  };


  static Goal fromJson(Map<String, dynamic> json) => Goal(
    goal_name: json['goal_name'],
    goal_id: json['goal_id']
  );
}