//I use this model to load invoice in invoice page

class InvoiceData {
  int? id;
  String? totalItem;
  User? user;
  Customer? customer;
  String? date;
  String? subTotal;
  String? discount;
  String? vat;
  String? tax;
  String? total;
  String? invoiceNo;
  List<InvoiceProduct>? invoiceProduct;

  InvoiceData(
      {this.id,
        this.totalItem,
        this.user,
        this.customer,
        this.date,
        this.subTotal,
        this.discount,
        this.vat,
        this.tax,
        this.total,
        this.invoiceNo,
        this.invoiceProduct});

  InvoiceData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    totalItem = json['total_item'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    date = json['date'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    vat = json['vat'];
    tax = json['tax'];
    total = json['total'];
    invoiceNo = json['invoice_no'];
    if (json['invoice_product'] != null) {
      invoiceProduct = <InvoiceProduct>[];
      json['invoice_product'].forEach((v) {
        invoiceProduct!.add(new InvoiceProduct.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['total_item'] = this.totalItem;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['date'] = this.date;
    data['sub_total'] = this.subTotal;
    data['discount'] = this.discount;
    data['vat'] = this.vat;
    data['tax'] = this.tax;
    data['total'] = this.total;
    data['invoice_no'] = this.invoiceNo;
    if (this.invoiceProduct != null) {
      data['invoice_product'] =
          this.invoiceProduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? mobile;

  User({this.id, this.name, this.mobile});

  User.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? phone;

  Customer({this.id, this.name, this.phone});

  Customer.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}

class InvoiceProduct {
  String? productName;
  String? qty;
  String? unit;
  String? unitPrice;
  String? discount;
  String? vat;
  String? tax;
  String? total;

  InvoiceProduct(
      {this.productName,
        this.qty,
        this.unit,
        this.unitPrice,
        this.discount,
        this.vat,
        this.tax,
        this.total});

  InvoiceProduct.fromJson(Map<dynamic, dynamic> json) {
    productName = json['product_name'];
    qty = json['qty'];
    unit = json['unit'];
    unitPrice = json['unit_price'];
    discount = json['discount'];
    vat = json['vat'];
    tax = json['tax'];
    total = json['total'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['product_name'] = this.productName;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['unit_price'] = this.unitPrice;
    data['discount'] = this.discount;
    data['vat'] = this.vat;
    data['tax'] = this.tax;
    data['total'] = this.total;
    return data;
  }
}