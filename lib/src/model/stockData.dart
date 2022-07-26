class StockData {
  int? id;
  String? user;
  String? productId;
  String? baseUnit;
  String? conversionRate;
  String? qty;
  String? unit;

  StockData(
      {this.id,
        this.user,
        this.productId,
        this.baseUnit,
        this.conversionRate,
        this.qty,
        this.unit});

  StockData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    user = json['user'];
    productId = json['product_id'];
    baseUnit = json['base_unit'];
    conversionRate = json['conversion_rate'];
    qty = json['qty'];
    unit = json['unit'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['product_id'] = this.productId;
    data['base_unit'] = this.baseUnit;
    data['conversion_rate'] = this.conversionRate;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    return data;
  }
}
