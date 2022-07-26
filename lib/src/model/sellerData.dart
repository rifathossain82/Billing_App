class SellerData {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  String? address;
  String? avatar;
  String? dob;
  String? isActive;

  SellerData(
      {this.id,
        this.userId,
        this.name,
        this.email,
        this.countryCode,
        this.phone,
        this.address,
        this.avatar,
        this.dob,
        this.isActive});

  SellerData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['mobile'];
    address = json['address'];
    avatar = json['avatar'];
    dob = json['dob'];
    isActive = json['is_active'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['dob'] = this.dob;
    data['is_active'] = this.isActive;
    return data;
  }
}