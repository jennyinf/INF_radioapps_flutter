class Sponsor {
  String logo;
  String website;
  String name;
  String? bannerColor;
  String? title;

  Sponsor({
    required this.logo,
    required this.website,
    required this.name,
    this.bannerColor,
    this.title,
  });

  // Convert Sponsor to JSON
  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'website': website,
      'name': name,
      'bannerColor': bannerColor,
      'title': title,
    };
  }

  factory Sponsor.fromJson(Map<String, dynamic> json) {
    return Sponsor(
      logo: json['logo'] as String,
      website: json['website'] as String,
      name: json['name'] as String,
      bannerColor: json['bannerColor'] as String?,
      title: json['title'] as String?,
    );
  }
}
