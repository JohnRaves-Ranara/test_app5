class LT_note{
  String LT_note_text;
  String LT_note_ID;
  String LT_note_title;
  // String creationDate;

  LT_note({required this.LT_note_text, required this.LT_note_ID, required this.LT_note_title});

  Map<String, dynamic> toJson() => {
    'LT_note_ID': LT_note_ID,
    'LT_note_text' : LT_note_text,
    'LT_note_title' : LT_note_title,
    // 'creationDate' : creationDate
  };


  static LT_note fromJson(Map<String, dynamic> json) => LT_note(
    LT_note_ID: json['LT_note_ID'],
    LT_note_text: json['LT_note_text'],
    LT_note_title: json['LT_note_title'],
    //creationDate: json['creationDate']

  );
}