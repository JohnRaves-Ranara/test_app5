
class Goal{
  final String goal_name;
  String? goal_id;
  String? goal_description;
  String? goal_banner_URL;

  Goal({required this.goal_name, this.goal_id, this.goal_description, this.goal_banner_URL});


  Map<String, dynamic> toJson() => {
    'goal_name': goal_name,
    'goal_id' : goal_id,
    'goal_description' : goal_description,
    'goal_banner_URL' : goal_banner_URL,
  };


  static Goal fromJson(Map<String, dynamic> json) => Goal(
    goal_name: json['goal_name'],
    goal_id: json['goal_id'],
    goal_description: json['goal_description'],
    goal_banner_URL: json['goal_banner_URL']
  );
}