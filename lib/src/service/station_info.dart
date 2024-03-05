class StationInfo {
  final int substationId;
  final String stationName;
  String streamURL;
  String twitterURL;
  String facebookPage;
  bool useFreeStreamer;

  StationInfo({
    required this.substationId,
    required this.stationName,
    this.streamURL = "",
    this.twitterURL = "",
    this.facebookPage = "",
    this.useFreeStreamer = false,
  });

  // Implementing == operator for Equatable
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StationInfo &&
        other.substationId == substationId &&
        other.stationName == stationName &&
        other.streamURL == streamURL &&
        other.twitterURL == twitterURL &&
        other.facebookPage == facebookPage &&
        other.useFreeStreamer == useFreeStreamer;
  }

  // Implementing hashCode for Equatable
  @override
  int get hashCode {
    return substationId.hashCode ^
        stationName.hashCode ^
        streamURL.hashCode ^
        twitterURL.hashCode ^
        facebookPage.hashCode ^
        useFreeStreamer.hashCode;
  }

  factory StationInfo.fromJson(Map<String, dynamic> json) {
    return StationInfo(
      substationId: json['substationId'] as int? ?? 0,
      stationName: json['stationName'] as String,
      streamURL: json['streamURL'] as String? ?? "", // Handle potential null values
      twitterURL: json['twitterURL'] as String? ?? "",
      facebookPage: json['facebookPage'] as String? ?? "",
      useFreeStreamer: json['useFreeStreamer'] as bool? ?? false,
    );
  }

  // Convert StationInfo to JSON
  Map<String, dynamic> toJson() {
    return {
      'substationId': substationId,
      'stationName': stationName,
      'streamURL': streamURL,
      'twitterURL': twitterURL,
      'facebookPage': facebookPage,
      'useFreeStreamer': useFreeStreamer,
      // Add other properties as needed
    };
  }
}
