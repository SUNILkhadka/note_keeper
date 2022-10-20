

// Note model class to store and retrive notes.
class Note{
  
  Note({
      this.id,
      required this.title,
      required this.note,
    });

  String? id;
  String title;
  String note;

  // object to Json
  Map<String,Object> toJson() => {
    'title': title,
    'note' : note,
   };


}