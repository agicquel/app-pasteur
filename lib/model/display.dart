class Display {
  final int id;
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
      id: json['id'],
      name: json['name'],
      message: json['message'],
      espId: json['espId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name,
        'message': message,
        'espId': espId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  @override
  String toString() {
    return '\nid = ' +
        id.toString() +
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
