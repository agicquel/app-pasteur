class DisplayHistory {
  final String id;
  final String user;
  final String message;
  final String modifierId;
  final String modifierType;
  final String time;

  DisplayHistory(
      { this.id,
        this.user,
        this.message,
        this.modifierId,
        this.modifierType,
        this.time });

  factory DisplayHistory.fromJson(Map<String, dynamic> json) {
    return DisplayHistory(
        id: json['_id'],
        user: json['user'] != null ? json['user'] : "",
        message: json['message'] != null ? json['message'] : "",
        modifierId: json['modifierId'],
        modifierType: json['modifierType'],
        time: json['time'] != null ? json['time'] : "",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'message': message,
    'modifierId': modifierId,
    'modifierType': modifierType,
    'time': time,
  };

}
