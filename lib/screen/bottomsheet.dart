class Member {
  String name;
  String memberid;
  String image;

  Member(this.name, this.memberid,this.image);

  Member.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    memberid = json['id'].toString();
    image = json['image'].toString();
  }
}