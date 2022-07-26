class UserData {
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? dob;
  String? address;
  String? avatar;
  String? token;
  String? userType;
  int? otp;
  Company? company;

  UserData(
      {this.id,
        this.name,
        this.email,
        this.countryCode,
        this.mobile,
        this.dob,
        this.address,
        this.avatar,
        this.token,
        this.userType,
        this.otp,
        this.company});

  UserData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    dob = json['dob'];
    address = json['address'];
    avatar = json['avatar'];
    token = json['token'];
    userType = json['user_type'];
    otp = json['otp'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['token'] = this.token;
    data['user_type'] = this.userType;
    data['otp'] = this.otp;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    return data;
  }
}

class Company {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? countryCode;
  String? avatar;
  String? address;

  Company(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.countryCode,
        this.avatar,
        this.address});

  Company.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    avatar = json['avatar'];
    address = json['address'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['country_code'] = this.countryCode;
    data['avatar'] = this.avatar;
    data['address'] = this.address;
    return data;
  }
}