class CountryCodeData {
  int? id;
  String? sort;
  String? countryName;
  String? countryCode;

  CountryCodeData({this.id, this.sort, this.countryName, this.countryCode});

  CountryCodeData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    sort = json['sort'] ?? '';
    countryName = json['country_name'] ?? '';
    countryCode = json['country_code'] ?? '';
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['sort'] = this.sort;
    data['country_name'] = this.countryName;
    data['country_code'] = this.countryCode;
    return data;
  }
}