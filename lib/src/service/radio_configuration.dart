import 'package:radioapps/src/service/data/serializer.dart';
import 'package:radioapps/src/service/sponsor.dart';
import 'package:radioapps/src/service/station_info.dart';

class RadioConfigurationSerializer extends Serializer<RadioConfiguration> {
  @override
  Map<String, dynamic> toJson(RadioConfiguration data) {
    return data.toJson();
  }

  @override
  RadioConfiguration fromJson(Map<String, dynamic> data) {
    return RadioConfiguration.fromJson(data);
  }
}


class RadioConfiguration {
  final bool active;
  final String stationNumber;
  final bool hasMultiStation;
  final String? backgroundColor;
  final String? foregroundColor;
  final String? barColor;
  final String? barIconColor;
  final bool showContactTab;

  final Sponsor? sponsor;
  final String? website;
  final String? donationsURL;
  final String? about;
  final String? podcastURL;
  final List<StationInfo> streams;
  const RadioConfiguration({
    this.active = false,
    this.stationNumber = "",
    this.hasMultiStation = false,
    this.backgroundColor,
    this.foregroundColor,
    this.barColor,
    this.barIconColor,
    this.showContactTab = true,
    this.sponsor,
    this.website,
    this.donationsURL,
    this.about,
    this.podcastURL,
    this.streams = const [],
  });

  factory RadioConfiguration.fromJson(Map<String, dynamic> json) {
    return RadioConfiguration(
      active: json['active'] as bool? ?? false,
      stationNumber: json['stationNumber'] as String? ?? "",
      hasMultiStation: json['hasMultiStation'] as bool? ?? false,
      backgroundColor: json['backgroundColor'] as String?,
      foregroundColor: json['foregroundColor'] as String?,
      barColor: json['barColor'] as String?,
      barIconColor: json['barIconColor'] as String?,
      showContactTab: json['showContactTab'] as bool? ?? false ,
      sponsor: json['sponsor'] != null ? Sponsor.fromJson(json['sponsor'] as Map<String, dynamic>) : null,
      website: json['website'] as String?,
      donationsURL: json['donationsURL'] as String?,
      about: json['about'] as String?,
      podcastURL: json['podcastURL'] as String?,
      streams: (json['streams'] as List<dynamic>? ?? []).map((e) => StationInfo.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'stationNumber': stationNumber,
      'hasMultiStation': hasMultiStation,
      'backgroundColor': backgroundColor,
      'foregroundColor': foregroundColor,
      'barColor': barColor,
      'barIconColor': barIconColor,
      'showContactTab': showContactTab,
      'sponsor': sponsor?.toJson(), // Convert Sponsor to JSON
      'website': website,
      'donationsURL': donationsURL,
      'about': about,
      'podcastURL': podcastURL,
      'streams': streams.map((stream) => stream.toJson()).toList(), // Convert List<StationInfo> to JSON
    };
  }

}
