//I use this model to sale product from cart screen

class SalesData {
  int? totalItem;
  double? totalPrice;
  double? tax;
  double? subTotal;
  int? customerId;
  double? discount;
  double? total;
  double? vat;
  List<Product>? product;

  SalesData(
      {this.totalItem,
        this.totalPrice,
        this.tax,
        this.subTotal,
        this.customerId,
        this.discount,
        this.total,
        this.vat,
        this.product});

  SalesData.fromJson(Map<dynamic, dynamic> json) {
    totalItem = json['total_item'];
    totalPrice = json['total_price'];
    tax = json['tax'];
    subTotal = json['sub_total'];
    customerId = json['customer_id'];
    discount = json['discount'];
    total = json['total'];
    vat = json['vat'];
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['total_item'] = this.totalItem;
    data['total_price'] = this.totalPrice;
    data['tax'] = this.tax;
    data['sub_total'] = this.subTotal;
    data['customer_id'] = this.customerId;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['vat'] = this.vat;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? invoiceId;
  int? productId;
  double? unitPrice;
  int? qty;
  double? salesQuantity;
  String? unit;
  double? discount;
  double? tax;
  double? vat;
  double? total;
  int? id;

  Product(
      {this.invoiceId,
        this.productId,
        this.unitPrice,
        this.qty,
        this.salesQuantity,
        this.unit,
        this.discount,
        this.tax,
        this.vat,
        this.total,
        this.id});

  Product.fromJson(Map<dynamic, dynamic> json) {
    invoiceId = json['invoice_id'];
    productId = json['product_id'];
    unitPrice = json['unit_price'];
    qty = json['qty'];
    salesQuantity = json['sales_qty'];
    unit=json['unit'];
    discount = json['discount'];
    tax = json['tax'];
    vat = json['vat'];
    total = json['total'];
    id = json['id'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['invoice_id'] = this.invoiceId;
    data['product_id'] = this.productId;
    data['unit_price'] = this.unitPrice;
    data['qty'] = this.qty;
    data['sales_qty'] = this.salesQuantity;
    data['unit']=this.unit;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['vat'] = this.vat;
    data['total'] = this.total;
    data['id'] = this.id;
    return data;
  }
}