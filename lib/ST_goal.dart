class ST_goal{
  final String ST_goal_name;
  String ST_goal_ID;
  String ST_goal_desc;
  String? ST_goal_status;

  ST_goal({this.ST_goal_status,required this.ST_goal_name,required this.ST_goal_ID,required this.ST_goal_desc,});


  Map<String, dynamic> toJson() => {
    'ST_goal_name': ST_goal_name,
    'ST_goal_ID' : ST_goal_ID,
    'ST_goal_desc' : ST_goal_desc,
    'ST_goal_status' : ST_goal_status
  };


  static ST_goal fromJson(Map<String, dynamic> json) => ST_goal(
    ST_goal_name: json['ST_goal_name'],
    ST_goal_ID: json['ST_goal_ID'],
    ST_goal_desc: json['ST_goal_desc'],
    ST_goal_status: json['ST_goal_status']
  );
}