class DashboardDataModel {
  int? customer;
  int? seller;
  int? sales;
  int? supplier;
  int? products;
  int? category;
  String? saleAmount;
  String? totalStock;

  DashboardDataModel(
      {this.customer,
        this.seller,
        this.sales,
        this.supplier,
        this.products,
        this.category,
        this.saleAmount,
        this.totalStock});

  DashboardDataModel.fromJson(Map<dynamic, dynamic> json) {
    customer = json['customer'];
    seller = json['seller'];
    sales = json['sales'];
    supplier = json['supplier'];
    products = json['products'];
    category = json['category'];
    saleAmount = json['sale_amount'];
    totalStock = json['total_stock'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['customer'] = this.customer;
    data['seller'] = this.seller;
    data['sales'] = this.sales;
    data['supplier'] = this.supplier;
    data['products'] = this.products;
    data['category'] = this.category;
    data['sale_amount'] = this.saleAmount;
    data['total_stock'] = this.totalStock;
    return data;
  }
}