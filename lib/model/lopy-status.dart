class LopyStatus {
  final String id;
  final String devEUI;
  final String appEUI;
  final int fPort;
  final int gatewayCount;
  final int rssi;
  final double loRaSNR;
  final int frequency;
  final String devAddr;
  final int fCntUp;
  final String time;
  final List<Gateway> gateways;
  final DataRate dataRate;

  LopyStatus({
    this.id,
    this.devEUI,
    this.appEUI,
    this.fPort,
    this.gatewayCount,
    this.rssi,
    this.loRaSNR,
    this.frequency,
    this.devAddr,
    this.fCntUp,
    this.time,
    this.gateways,
    this.dataRate
  });

  /*factory LopyStatus.fromJson(Map<String, dynamic> json) {
    return LopyStatus(
      id: json['_id'],
      mac: json['mac'],
      currentSeq: json['currentSeq'] != null ? json['currentSeq'] : -1,
      createdAt: json['createdAt'] != null ? json['createdAt'] : "",
      updatedAt: json['updatedAt'] != null ? json['updatedAt'] : "",
    );
  }*/

  Map<String, dynamic> toJson() => {
    'id': id,
  };


}

class Gateway {
  final String id;
  final String devEUI;
  final String appEUI;
  final int fPort;
  final int gatewayCount;
  final int rssi;
  final double loRaSNR;
  final int frequency;
  final String devAddr;
  final int fCntUp;
  final String time;
  final DataRate dataRate;

  Gateway({
    this.id,
    this.devEUI,
    this.appEUI,
    this.fPort,
    this.gatewayCount,
    this.rssi,
    this.loRaSNR,
    this.frequency,
    this.devAddr,
    this.fCntUp,
    this.time,
    this.dataRate
  });


}

class DataRate {
  final String id;
  final String modulation;
  final int spreadFactor;
  final int bandwidth;

  DataRate({
    this.id,
    this.modulation,
    this.spreadFactor,
    this.bandwidth
  });

}