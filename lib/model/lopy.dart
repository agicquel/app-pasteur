class Lopy {
  final String id;
  final String mac;
  final int currentSeq;
  final String createdAt;
  final String updatedAt;
  // TODO : lopy status array

  Lopy(
      {this.id,
        this.mac,
        this.currentSeq,
        this.createdAt,
        this.updatedAt});

  factory Lopy.fromJson(Map<String, dynamic> json) {
    return Lopy(
      id: json['_id'],
      mac: json['mac'],
      currentSeq: json['currentSeq'] != null ? json['currentSeq'] : -1,
      createdAt: json['createdAt'] != null ? json['createdAt'] : "",
      updatedAt: json['updatedAt'] != null ? json['updatedAt'] : "",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'mac': mac,
    'currentSeq': currentSeq.toString(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  @override
  String toString() {
    return '\nid = ' +
        id +
        '\nmac = ' +
        mac +
        '\ncurrentSeq = ' +
        currentSeq.toString() +
        '\ncreatedAt = ' +
        createdAt +
        '\nupdatedAt = ' +
        updatedAt;
  }
}
