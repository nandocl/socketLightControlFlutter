class LuzModel {
  LuzModel({
    this.id,
    this.name,
    this.chipId,
    this.state,
  });

  String id;
  String name;
  String chipId;
  bool state;

  factory LuzModel.fromJson(Map<String, dynamic> json) => LuzModel(
        id: json["_id"],
        name: json["name"],
        chipId: json["chipId"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "chipId": chipId,
        "state": state,
      };
}
