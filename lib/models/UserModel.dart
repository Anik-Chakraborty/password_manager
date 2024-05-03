class UserModel {
  String? token;
  int? id;
  String? name;
  String? email;

  UserModel({this.token, this.id, this.name, this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
