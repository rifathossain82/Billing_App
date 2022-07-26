class SupplierData {
  int? id;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? avatar;
  String? dob;
  String? balance;
  String? is_active;

  SupplierData({this.id, this.userId, this.name, this.email, this.phone, this.address, this.avatar, this.dob, this.balance,this.is_active});

  SupplierData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    avatar = json['avatar'];
    dob = json['dob'];
    balance = json['balance'];
    is_active = json['is_active'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['dob'] = this.dob;
    data['balance'] = this.balance;
    data['is_active'] = this.is_active;
    return data;
  }
}