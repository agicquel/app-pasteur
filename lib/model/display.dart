import 'package:lost_in_pasteur/model/display-history.dart';

class Display {
  final String id;
  final String name;
  final String message;
  final String espId;
  final String createdAt;
  final String updatedAt;
  final int lopyMessageSeq;
  final bool lopyMessageSync;
  final String lastLopy;
  final List<DisplayHistory> history;

  Display(
      {this.id,
      this.name,
      this.message,
      this.espId,
      this.createdAt,
      this.updatedAt,
      this.lopyMessageSeq,
      this.lopyMessageSync,
      this.lastLopy,
      this.history});

  factory Display.fromJson(Map<String, dynamic> json) {
    List hist = json['history'] != null ? json['history'] as List : List;

    return Display(
      id: json['_id'] != null ? json['_id'] : json['espId'],
      name: json['name'] != null ? json['name'] : "Afficheur",
      message: json['message'],
      espId: json['espId'],
      createdAt: json['createdAt'] != null ? json['createdAt'] : "",
      updatedAt: json['updatedAt'] != null ? json['updatedAt'] : "",
      lopyMessageSeq: json['lopyMessageSeq'] != null ? json['lopyMessageSeq'] : -1,
      lopyMessageSync: json['lopyMessageSync'] != null ? json['lopyMessageSync'] : false,
      lastLopy: json['lastLopy'] != null ? json['lastLopy'] : "",
      history: hist.map((h) => DisplayHistory.fromJson(h)).toList().reversed.toList()
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'message': message,
        'espId': espId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'lopyMessageSeq': lopyMessageSeq.toString(),
        'lopyMessageSync': lopyMessageSync.toString(),
        'lastLopy': lastLopy,
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
        updatedAt +
        '\nlopyMessageSeq = ' +
        lopyMessageSeq.toString() +
        '\nlopyMessageSync = ' +
        lopyMessageSync.toString() +
        '\nlastLopy = ' +
        lastLopy +
        '\nhistory (' + history.length.toString() + ')' ;
  }
}
