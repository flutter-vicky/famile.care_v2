
class Time{
  String date;
  String doc;
  String time;
  String username;
  String id;
  List images;
  String firstimage;
  String count;
  int groupid;

  Time(this.date,this.doc,this.time,this.username,this.id,this.images,this.firstimage,this.count,this.groupid);

  Time.fromJson(Map<String,dynamic> json){
    date = json['date'];
    time = json['time'];
    doc = json['total_docs'];
    username = json['username'];
    id = json['profile_id'].toString();
    images = json['image_links'].map((m) => m as String).toList();
    firstimage = json['first_image'];
    count = json['count'];
    groupid = json['id'];
  }
}