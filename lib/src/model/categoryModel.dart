class CategoryModel {
  int? id;
  String? name;
  String? isActive;

  CategoryModel({this.id, this.name, this.isActive});

  CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    return data;
  }
}
