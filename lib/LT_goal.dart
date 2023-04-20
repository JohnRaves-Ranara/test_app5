class LT_goal{

  String LT_goal_ID;
  String LT_goal_name;
  String LT_goal_desc;
  String LT_goal_banner;
  String LT_goal_status;

  LT_goal({required this.LT_goal_status,required this.LT_goal_banner, required this.LT_goal_ID,required this.LT_goal_name,required this.LT_goal_desc});

  Map<String, dynamic> toJson() => {
    'LT_goal_ID': LT_goal_ID,
    'LT_goal_name' : LT_goal_name,
    'LT_goal_desc' : LT_goal_desc,
    'LT_goal_banner' : LT_goal_banner,
    'LT_goal_status' : LT_goal_status,
  };


  static LT_goal fromJson(Map<String, dynamic> json) => LT_goal(
    LT_goal_ID: json['LT_goal_ID'],
    LT_goal_name: json['LT_goal_name'],
    LT_goal_desc: json['LT_goal_desc'],
    LT_goal_banner: json['LT_goal_banner'],
    LT_goal_status: json['LT_goal_status'],
  );
}

