import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/model/productData.dart';
import 'package:billing_app/src/model/salesData.dart';
import 'package:billing_app/src/model/userModel.dart';
import 'package:billing_app/src/pages/sales/sales_screen.dart';
import 'package:billing_app/src/widgets/confirmationDialog.dart';
import 'package:billing_app/src/widgets/customDialog.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/myButton.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../controller/authenticationController.dart';
import '../../controller/currencyController.dart';
import '../../controller/salesController.dart';
import '../../model/cartData.dart';
import '../../model/customerData.dart';
import '../../model/invoice.dart';
import '../../services/api/pdf_api/pdf_api.dart';
import '../../services/api/pdf_api/pdf_invoice_api.dart';
import '../../widgets/showToastMessage.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  TextEditingController quantityController=TextEditingController();
  TextEditingController discountController=TextEditingController();
  TextEditingController customerController=TextEditingController();
  TextEditingController totalAmountController=TextEditingController();
  TextEditingController stockController=TextEditingController();

  //to find user
  var authenticationController=Get.find<AuthenticationController>();
  var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

  final salesController=Get.put(SalesController());
  UserData user=UserData();


  //to store all cart item
  List<CartData> cartList=[];

  //to find total Amount , total tax and price incl tax
  var totalItem=0;
  double totalPrice=0;
  double totalTaxPercentage=0;
  double taxAmount=0;
  double totalPriceInclTax=0;
  double discount=0;
  double finalAmount=0;


  var customerName;
  CustomerData customer=CustomerData();
  var paymentMethod;
  late List<String> paymentMethodList;
  late List<String> paymentMethodListSubTitle;

  @override
  void initState() {
    //to fetch cart product
    getCartData();

    //to fetch current user
    user=authenticationController.user[0];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ///to load localizations text
    if(customer.name.toString().isEmpty || customer.name==null){
      customerName=AppLocalizations.of(context)!.selectCustomer;
    }

    paymentMethodList=[
      AppLocalizations.of(context)!.cash,
      AppLocalizations.of(context)!.cardBankCheque,
      AppLocalizations.of(context)!.credit,
    ];

    paymentMethodListSubTitle=[
      AppLocalizations.of(context)!.collectByHand,
      AppLocalizations.of(context)!.cardBankCheque+ " "+ AppLocalizations.of(context)!.collectBy,
      AppLocalizations.of(context)!.savedAsCredit,
    ];

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    quantityController.dispose();
    discountController.dispose();
    customerController.dispose();
    totalAmountController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void getCartData() async {
    //set all data
    cartList=[];
    totalItem=0;
    totalPrice=0;
    totalTaxPercentage=0;
    taxAmount=0;
    totalPriceInclTax=0;
    finalAmount=0;

    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> jsonData =
    jsonDecode(prefs.getString('cartList') ?? '[]');
    var cartList_ = jsonData.map<CartData>((jsonItem) {
      return CartData.fromJson(jsonItem);
    }).toList();
    setState(() {});

    cartList.addAll(cartList_);
    print(cartList.length);


    for(int i=0; i<cartList.length; i++){
      setState(() {
        double price=double.parse(cartList[i].price.toString());    //single item price
        int quantity=int.parse(cartList[i].salesQuantity.toString());   //product quantity
        double tax=double.parse(cartList[i].tax.toString());            //product tax

        double totalPrice_perProduct=price*quantity;          //total price of a product based on item price and quantity

        totalItem++;      //count how many item are in cart
        totalPrice = totalPrice + totalPrice_perProduct;         //find out total price without tax of cartlist
        taxAmount=taxAmount+((totalPrice_perProduct*tax)/100);   //calculate
      });
    }

    totalPriceInclTax=totalPrice+taxAmount;
    finalAmount=totalPriceInclTax;
  }


  //clear all cart data
  void deleteAllData()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cartList');

    RefreshSalesScreen().refresh();   //to refresh sales screen after delete single cart item

    getCartData();
  }

  void deleteProduct(int? index)async{
    var newList=[];
    for(int i=0; i < cartList.length; i++){
      if(i == index){
        //cartList.removeAt(i);
      }
      else{
        newList.add(cartList[i]);
      }
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cartList', jsonEncode(newList));

    RefreshSalesScreen().refresh();   //to refresh sales screen after delete single cart item

    getCartData();
  }


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cart,),
        foregroundColor: myblack,
        elevation: 0,
        backgroundColor: myWhite,
        actions: [
          cartList.isNotEmpty?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: InkWell(
              onTap: ()async{
                var result = await confirmationDialog(context: context,
                    title: AppLocalizations.of(context)!.deleteAllMsg,
                    negativeActionText: AppLocalizations.of(context)!.no,
                    positiveActionText: AppLocalizations.of(context)!.yes);

                if(result==true){
                  deleteAllData();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    child: Text(
                        AppLocalizations.of(context)!.delete,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  )
              ),
            ),
          )
              :
          Container()
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: cartList.isEmpty?
        Center(
          child: ShowNoItem(iconData: Icons.shopping_cart, title: AppLocalizations.of(context)!.noItemsAdded),
        )
            :
        ListView(
          children: [

            ///here is all product in list
            ListView.builder(
              itemCount: cartList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return buildProduct(size, cartList[index], index);
              },
            ),

            buildAmount(size),

            buildCustomer(size),
            SizedBox(height: size.height*0.01,),
            buildDiscount(size),
            Divider(color: Colors.black38,),
            buildTotalAmount(size),
            SizedBox(height: size.height*0.05,),
            myButton(
              onTap: (){
                if(customerName.toString().isEmpty || customerName.toString()=='Select Customer') {
                  showToastMessage('Select a customer');
                }
                else{
                  buildBottomSheet(size, context);
                }
              },
              buttonText: AppLocalizations.of(context)!.pay,
              paddingHorizontal: 16,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: size.height*0.03,),
            SizedBox(height: size.height*0.03,),
          ],
        ),
      ),
    );
  }

  Widget buildProduct(Size size, CartData data, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ///product image here
                Expanded(
                  flex: 1,
                  child: buildProductImage(data.avatar),
                ),
                SizedBox(width: size.width*0.05,),

                ///product info and action here
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ///product name and delete button here
                      Row(
                        children: [
                          Expanded(child: AutoSizeText('${data.name}',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor2),maxLines: 3,)),
                          SizedBox(width: size.width*0.03,),
                          IconButton(
                            onPressed: ()async{
                              var result = await confirmationDialog(context: context,
                                  title: AppLocalizations.of(context)!.deleteMsg,
                                  negativeActionText: AppLocalizations.of(context)!.cancel,
                                  positiveActionText: AppLocalizations.of(context)!.delete);

                              if(result==true){
                                deleteProduct(index);
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red,)
                          ),
                        ],
                      ),

                      ///product price , quantity number and quantity buttons here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ///product price and quantity number here
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${data.price} $currency',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              Text('Qty : ${data.salesQuantity} ${data.selectedUnit}', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              changeQuantityAlertDialog(size, data, index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(Icons.price_change, color: textColor2,),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductImage(var imgUrl){
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
      ),
      child: CachedNetworkImage(
        imageUrl: '$imgUrl',
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  void changeQuantityAlertDialog(Size size, CartData data, int index){

    List<ProductStock>? stockList = data.stockList;

    for(int i=0; i<stockList!.length; i++){
      print(stockList[i].unit);
      print(stockList[i].baseUnit);
      print(stockList[i].conversionRate);
      print(stockList[i].price);
    }

    //set unitTypes
    List<String> unitTypes=[];
    stockList.forEach((element) {
      unitTypes.add(element.unit.toString());
    });


    int quantity= data.salesQuantity!;
    quantityController.text = data.salesQuantity.toString();

    int max_quantity = data.maxQuantity!;
    stockController.text = data.maxQuantity.toString();

    var selectedUnit = data.selectedUnit;
    double productPrice = double.parse(data.price.toString());
    int stock=int.parse(data.totalStock.toString());
    int totalStock=int.parse(data.totalStock.toString());


    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                  title: Text(AppLocalizations.of(context)!.changeQuantity),
                  titleTextStyle: TextStyle(color: textColor2, fontWeight: FontWeight.w600, fontSize: 24),
                  scrollable: true,
                  content: SizedBox(
                    height: size.height*0.3,
                    child: Column(
                      children: [


                        ///unit type here
                        Row(
                          children: [

                            //here is unitType drop down
                            Expanded(
                              child: Container(
                                height: size.height*0.06,
                                width: size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      elevation: 0,
                                      value: selectedUnit,
                                      onChanged: (val){
                                        setState(() {
                                          if(val!=selectedUnit){
                                            selectedUnit=val!;
                                            int? unitIndex;
                                            for(int i =0; i<stockList.length; i++){
                                              if(selectedUnit == stockList[i].unit){
                                                productPrice = double.parse(stockList[i].price.toString());
                                                unitIndex = i;
                                              }
                                            }

                                            int  qty = totalStock;
                                            for(int i=stockList.length - 1; i > unitIndex!; i--){
                                              int conversionRate = double.parse(stockList[i].conversionRate.toString()).toInt();
                                              qty = qty ~/ conversionRate;
                                            }

                                            print(qty);
                                            stock = qty;
                                            max_quantity = stock;
                                            stockController.text = stock.toString();

                                          }
                                        });
                                      },
                                      items: unitTypes.map<DropdownMenuItem<String>>((String? val){
                                        return DropdownMenuItem(
                                          child: Text(val!,style: const TextStyle(color: Colors.black),),
                                          value: val,
                                        );
                                      }).toList(),
                                      dropdownColor: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              )
                            ),
                            SizedBox(width: size.width*0.03,),

                            //here is stock textField
                            Expanded(
                              child: TextField(
                                controller: stockController,
                                maxLines: 1,
                                readOnly: true,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  prefixText: AppLocalizations.of(context)!.stock+": ",
                                  border: OutlineInputBorder(),
                                ),
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: size.height*0.02,),

                        ///quantity section here
                        Row(
                          children: [
                          ///minus button
                          InkWell(
                            onTap:(){
                              setState(() {
                                  if(quantity<=1){
                                  showToastMessage('${AppLocalizations.of(context)!.lessQuantityMsg}');
                                }
                                else{
                                  quantity--;
                                  quantityController.text=quantity.toString();
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: mainColor.withOpacity(0.2),
                              ),
                              child: Icon(CupertinoIcons.minus,color: mainColor,),
                            ),
                          ),
                          SizedBox(width: 8,),

                          ///show number
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: mainColor.withOpacity(0.2),
                              ),
                              alignment: Alignment.center,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                onSubmitted: (val){
                                  setState((){
                                    quantity=int.parse(quantityController.text.toString());
                                    //print(quantity);
                                  });
                                },
                                style: TextStyle(color: mainColor, fontSize: 20),
                                controller: quantityController,
                                decoration: InputDecoration(
                                  border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),

                          ///plus button
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(quantity>=max_quantity){
                                  showToastMessage('${AppLocalizations.of(context)!.bigQuantityMsg}');
                                }
                                else{
                                  quantity++;
                                  quantityController.text=quantity.toString();
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: mainColor.withOpacity(0.2),
                              ),
                              child: Icon(Icons.add,color: mainColor,),
                            ),
                          ),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    myButton(
                        onTap: (){
                          if(quantity>max_quantity){
                            showToastMessage('${AppLocalizations.of(context)!.bigQuantityMsg}');
                          }
                          else{
                            //set edited data
                            cartList[index].salesQuantity=quantity;
                            cartList[index].price=productPrice.toString();
                            cartList[index].selectedUnit=selectedUnit.toString();
                            cartList[index].maxQuantity=max_quantity;

                            //set cartList data in locale again
                            addCartDataInLocale(cartList);

                            //to refresh data and page
                            setState((){
                              getCartData();
                            });
                            Navigator.pop(context);
                          }
                        },
                        buttonText: '${AppLocalizations.of(context)!.ok}',
                        paddingHorizontal: 16
                    )
                  ],
                );
              }
          );
        }
    );
  }

  Widget buildAmount(Size size){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Divider(color: Colors.black38,),
          buildSingleAmount('${AppLocalizations.of(context)!.total}: (${totalItem} ${AppLocalizations.of(context)!.itemsInCart})', '${totalPrice.toStringAsFixed(2)}'),
          buildSingleAmount('${AppLocalizations.of(context)!.taxAmount}:', '${taxAmount.toStringAsFixed(2)}'),
          buildSingleAmount('${AppLocalizations.of(context)!.totalIncTax}:', '${totalPriceInclTax.toStringAsFixed(2)}'),
          Divider(color: Colors.black38,),
        ],
      ),
    );
  }

  Widget buildSingleAmount(String name, String amount){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          AutoSizeText('${name}', style: TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.w600),),
          Spacer(),
          AutoSizeText('${amount}', style: TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }

  Widget buildCustomer(Size size){
    return InkWell(
      onTap: ()async{
        var result=await Get.toNamed(RouteGenerator.selectCustomer);

        setState(() {
          if(result != null){
            customerName=result.name;
            customer=result;
          }

        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.customer, style: TextStyle(fontSize: 16, color: Colors.black87),),
            Spacer(),
            Text('${customerName}', style: TextStyle(fontSize: 14, color: Colors.black87),),
            SizedBox(height: size.width*0.01,),
            Icon(Icons.arrow_forward_ios_sharp,size: 14,),
          ],
        ),
      ),
    );
  }

  Widget buildDiscount(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${AppLocalizations.of(context)!.discount} ($currency)', style: TextStyle(fontSize: 16, color: Colors.black87),),
          Spacer(),
          Expanded(
            child: TextField(
              controller: discountController,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              onEditingComplete: (){
                setState(() {

                  //to hide keyboard
                  Util.hideKeyboard(context);

                  if(discountController.text.isNotEmpty){
                    discount=double.parse(discountController.text.toString());
                    finalAmount=totalPriceInclTax-discount;
                  }

                });
              },
              decoration: InputDecoration(
                hintText: '0.00',
                border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalAmount(Size size){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.totalPrice, style: TextStyle(fontSize: 16, color: Colors.black87),),
          Spacer(),
          Text('${finalAmount.toStringAsFixed(2)} $currency', style: TextStyle(fontSize: 16, color: Colors.black87),),
        ],
      ),
    );
  }

  Future buildBottomSheet(Size size, BuildContext context){
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return SizedBox(
          height: size.height*0.4,
          child: buildPaymentItem()
        );
      },
    );
  }

  Widget buildPaymentItem(){
    paymentMethod='';
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            itemCount: paymentMethodList.length,
            itemBuilder: (context, index){
              return RadioListTile(
                title: Text(paymentMethodList[index]),
                subtitle: Text(paymentMethodListSubTitle[index]),
                value: paymentMethodList[index],
                groupValue: paymentMethod,
                onChanged: (val){
                  setState(() {
                    paymentMethod=val;
                  });

                  //to sale product this is the method
                  addSale();

                },
              );
            },
          ),
        );
      },
    );
  }

  void addSale()async{
    //to close opening bottom sheet of payment methods
    Get.back();

    //to show loader
    customDialog();

    //to get item
    List<Product> itemList=[];
    List<InvoiceItem> invoiceItemList=[];

    //to fetch cartList product
    for(int i=0; i<cartList.length; i++) {
      //find total amount per product
      double price = double.parse(cartList[i].price.toString());
      int qty = int.parse(cartList[i].salesQuantity.toString());
      double tax = double.parse(cartList[i].tax.toString());
      double totalPrice = price * qty;


      //to find out the total sales quantity for decrement stock by sales api
      int selectedUnitIndex=0;
      for(int j=0; j<cartList[i].stockList!.length; j++){
        if(cartList[i].selectedUnit==cartList[i].stockList![j].unit){
          selectedUnitIndex = j;
        }
      }

      double salesQuantityPerProduct = qty.toDouble() ;
      for(int k=selectedUnitIndex+1; k<cartList[i].stockList!.length; k++){
        double d = double.parse(cartList[i].stockList![k].conversionRate.toString());
        salesQuantityPerProduct *= d;
      }
      //end here to finding total sales quantity


      //to sale product by api we need product item
      Product item = Product(
          productId: cartList[i].id,
          unit: cartList[i].selectedUnit.toString(),
          unitPrice: price,
          qty: qty,
          salesQuantity: salesQuantityPerProduct,
          discount: 0,
          tax: tax,
          vat: 0,
          total: totalPrice
      );

      //to create invoice we need invoice item
      InvoiceItem invoiceItem=InvoiceItem(
          productName: cartList[i].name,
          qty: qty.toString(),
          unit: cartList[i].selectedUnit.toString(),
          unitPrice: price,
          vat: 0,
          tax: tax,
          discount: '0',
          total: totalPrice
      );


      itemList.add(item);
      invoiceItemList.add(invoiceItem);
    }


    SalesData salesData=SalesData(
      totalItem: totalItem,
      totalPrice: totalPrice,
      tax: taxAmount,
      subTotal: totalPriceInclTax,
      customerId: customer.id,
      discount: discount,
      total: finalAmount,
      vat: 0,
      product: itemList,
    );


    print(salesData.totalPrice);
    var invNumber= await salesController.addSale(salesData);

    //close opening loader
    if(Get.isDialogOpen==true){
      Get.back();
    }

    if(invNumber.toString().isNotEmpty && salesController.isSales.value){

      ///to create invoice
      await createInvoice(invoiceItemList, invNumber);

      ///to clear all item from cart
      deleteAllData();
    }
    else{
      showToastMessage('Sales Failed!');
    }
  }

  Future<void> createInvoice(List<InvoiceItem> itemList, var invNumber)async{

    try{
      final date=DateTime.now();
      final invoiceInfo=InvoiceInfo(
          date: date,
          businessName: '${user.company!.name}',
          email: '${user.company!.email}',
          mobile: '${user.company!.mobile}',
          countryCode: '${user.company!.countryCode}',
          address: '${user.company!.address}',
          number: '$invNumber',
          discount: discount
      );

      final seller=Seller(
        id: user.id.toString(),
        name: user.name.toString(),
        countryCode: user.countryCode.toString(),
        phone: user.mobile.toString()
      );

      final invoice=Invoice(
          info: invoiceInfo,
          seller: seller,
          customerData: customer,
          items: itemList
      );

      final pdfFile=await PdfInvoiceApi.generate(invoice);

      print('my pdf file location $pdfFile');

      PdfApi.openFile(pdfFile);
    }catch(e){
      print(e);
      showToastMessage('Unable to load invoice.');
    }

  }

  Future<void> addCartDataInLocale(List<CartData> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cartList', jsonEncode(list));
  }
}
