class Display {
  final String id;
  final String name;
  final String message;
  final String espId;
  final String createdAt;
  final String updatedAt;

  Display(
      {this.id,
      this.name,
      this.message,
      this.espId,
      this.createdAt,
      this.updatedAt});

  factory Display.fromJson(Map<String, dynamic> json) {
    return Display(
      id: json['_id'] != null ? json['_id'] : json['espId'],
      name: json['name'] != null ? json['name'] : "Afficheur",
      message: json['message'],
      espId: json['espId'],
      createdAt: json['createdAt'] != null ? json['createdAt'] : "",
      updatedAt: json['updatedAt'] != null ? json['updatedAt'] : "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'message': message,
        'espId': espId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  @override
  String toString() {
    return '\nid = ' +
        id +
        '\nname = ' +
        name +
        '\nmessage = ' +
        message +
        '\nespId = ' +
        espId +
        '\ncreatedAt = ' +
        createdAt +
        '\nupdatedAt = ' +
        updatedAt;
  }
}
