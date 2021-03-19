class UserDetail {
  String name;
  String age;
  String blood;
  String height;
  String weight;
  String occupation;
  String email;
  String mobile;
  String state;
  String city;
  String gender;
  String address;
  String image;
  List images;

  UserDetail({this.name,this.age,this.blood,this.height,this.weight,this.occupation,this.email,this.mobile,this.state,this.city,this.address,this.image});
  UserDetail.fromJson(Map<String, dynamic> data){
       name = data['name'].toString();
        age = data['age'].toString();
        blood = data['blood_group'].toString();
        height = data['height'].toString();
        weight = data['weight'].toString();
        occupation = data['occupation'].toString();
        email = data['email'].toString();
        gender = data['gender'].toString();
        mobile = data['phone'].toString();
        state = data['state'].toString();
        city = data['city'].toString();
        address = data['address'].toString();
        images = data['image_links'].map((m) => m as String).toList();
        image = data['image'].toString();
}}