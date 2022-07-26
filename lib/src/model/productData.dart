class ProductData {
  int? id;
  String? user;
  ProductCategory? category;
  ProductSupplier? supplier;
  String? name;
  String? brand;
  String? code;
  String? avatar;
  String? purchasePrice;
  String? salePrice;
  String? qty;
  String? manufacture;
  String? tax;
  String? isActive;
  List<ProductStock>? stock;

  ProductData(
      {this.id,
        this.user,
        this.category,
        this.supplier,
        this.name,
        this.brand,
        this.code,
        this.avatar,
        this.purchasePrice,
        this.salePrice,
        this.qty,
        this.manufacture,
        this.tax,
        this.isActive,
        this.stock});

  ProductData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    user = json['user'];
    category = json['category'] != null
        ? new ProductCategory.fromJson(json['category'])
        : null;
    supplier = json['supplier'] != null
        ? new ProductSupplier.fromJson(json['supplier'])
        : null;
    name = json['name'];
    brand = json['brand'];
    code = json['code'];
    avatar = json['avatar'];
    purchasePrice = json['purchase_price'];
    salePrice = json['sale_price'];
    qty = json['qty'];
    manufacture = json['manufacture'];
    tax = json['tax'];
    isActive = json['is_active'];
    if (json['stock'] != null) {
      stock = <ProductStock>[];
      json['stock'].forEach((v) {
        stock!.add(new ProductStock.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.supplier != null) {
      data['supplier'] = this.supplier!.toJson();
    }
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['code'] = this.code;
    data['avatar'] = this.avatar;
    data['purchase_price'] = this.purchasePrice;
    data['sale_price'] = this.salePrice;
    data['qty'] = this.qty;
    data['manufacture'] = this.manufacture;
    data['tax'] = this.tax;
    data['is_active'] = this.isActive;
    if (this.stock != null) {
      data['stock'] = this.stock!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductCategory {
  int? id;
  String? name;

  ProductCategory({this.id, this.name});

  ProductCategory.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ProductSupplier {
  int? id;
  String? name;

  ProductSupplier({this.id, this.name});

  ProductSupplier.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ProductStock {
  int? id;
  String? productId;
  String? isBase;
  String? conversionRate;
  String? unit;
  String? baseUnit;
  String? price;

  ProductStock({this.id, this.productId, this.isBase, this.conversionRate, this.unit, this.baseUnit, this.price});

  ProductStock.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    isBase = json['is_base'];
    conversionRate = json['conversion_rate'];
    unit = json['unit'];
    baseUnit = json['base_unit'];
    price = json['price'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['is_base'] = this.isBase;
    data['conversion_rate'] = this.conversionRate;
    data['unit'] = this.unit;
    data['base_unit'] = this.baseUnit;
    data['price'] = this.price;
    return data;
  }
}