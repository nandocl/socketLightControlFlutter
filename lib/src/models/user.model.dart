class UserItemModel {
  UserItemModel(
      {this.name, this.user, this.id, this.token, this.email, this.phone});

  String id;
  String name;
  String user;
  String email;
  String phone;
  String token;

  factory UserItemModel.fromJson(Map<String, dynamic> json) => UserItemModel(
        id: json["id"],
        name: json["name"],
        user: json["user"],
        email: json["email"],
        phone: json["phone"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user": user,
        "email": email,
        "phone": phone,
        "token": token,
      };
}
