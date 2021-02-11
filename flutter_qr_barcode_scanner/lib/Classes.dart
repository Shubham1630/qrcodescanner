class QRCode {
  String qrCodeData;
  String currentdate;


  QRCode({
    this.qrCodeData,
    this.currentdate

  });

  static Map<String, dynamic> toMap(QRCode qrCode) => {
    'qrCodeData': qrCode.qrCodeData,
    'currentdate': qrCode.currentdate

  };

  Map<String, dynamic> toJson() => {
    'qrCodeData': qrCodeData,
    'currentdate': currentdate,


  };

  QRCode.fromJson(Map<String, dynamic> json)
      : qrCodeData = json['qrCodeData'],
        currentdate = json['currentdate'];

}


