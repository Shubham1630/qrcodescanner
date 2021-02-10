class DirectoryOS {
  String dirName;
  String currentdate;


  DirectoryOS({
    this.dirName,
    this.currentdate

  });

  static Map<String, dynamic> toMap(DirectoryOS directoryOS) => {
    'dirName': directoryOS.dirName,
    'currentdate': directoryOS.currentdate

  };

  Map<String, dynamic> toJson() => {
    'dirName': dirName,
    'currentdate': currentdate,


  };

  DirectoryOS.fromJson(Map<String, dynamic> json)
      : dirName = json['dirName'],
        currentdate = json['currentdate'];

}


