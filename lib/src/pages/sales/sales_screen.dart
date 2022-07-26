import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/productController.dart';
import 'package:billing_app/src/widgets/customBadge.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../controller/currencyController.dart';
import '../../model/cartData.dart';
import '../../model/productData.dart';
import '../../widgets/appBar_bg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/decoration/searchTextFieldDecoration_.dart';
import '../../widgets/myButton.dart';
import '../../widgets/showToastMessage.dart';

class SalesScreen extends StatefulWidget {
  SalesScreen({Key? key}) : super(key: key);

  final productController=Get.put(ProductController());

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  TextEditingController searchController=TextEditingController();
  TextEditingController quantityController=TextEditingController();
  var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

  ScrollController _scrollController = ScrollController();
  var pageNumber=Get.find<ProductController>().pageNumber;

  var scanResult;
  int cartItemLength=0;

  //to save item in cart
  List<CartData> cartList=[];

  @override
  void dispose() {
    searchController.dispose();
    quantityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    getCartData();
    scrollIndicator();
    super.initState();
  }

  searchMethod(){
    print(searchController.text.toString());

    if(searchController.text.toString().isEmpty){
      RefreshSalesScreen().refresh();
    }
    else{
      widget.productController.getData(name: searchController.text.toString());
    }
  }

  void scrollIndicator() {
    _scrollController.addListener(
          () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          print('reach to bottom');
          if(!Get.find<ProductController>().loadedCompleted.value){
            ++widget.productController.pageNumber.value;
            widget.productController.getData();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sales),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: AppBar_bg(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Util().preferredHeight),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (val)=>searchMethod(),
                    onChanged: (val) {
                      if(val.length >= 3){
                        searchMethod();
                      }
                    },
                    decoration: searchTextFieldDecoration_(AppLocalizations.of(context)!.search, searchController, searchMethod),
                  ),
                ),
                SizedBox(width: size.width*0.02,),
                Expanded(
                  flex: 1,
                  child: buildScanner(size)
                ),
              ],
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: RefreshIndicator(
          child: GetX<ProductController>(builder: (controller){
            if(controller.isLoading.value){
              return Center(
                child: Image.asset('assets/icons/loading.gif'),
              );
            }
            else if(controller.isLoading.value==false && controller.products.isEmpty){
              return Stack(
                children: [
                  ListView(),
                  Center(
                    child: ShowNoItem(title: AppLocalizations.of(context)!.noDataFound),
                  )
                ],
              );
            }
            else{
              return ListView.builder(
                controller: _scrollController,
                itemCount: controller.products.length+1,
                itemBuilder: (context, index){
                  if(index==controller.products.length &&
                      !Get.find<ProductController>().loadedCompleted.value){
                    return Center(
                      child: Image.asset('assets/icons/loading.gif'),
                    );
                  }
                  else if(index==controller.products.length &&
                      Get.find<ProductController>().loadedCompleted.value){
                    return Container();
                  }
                  else{
                    if(controller.products[index].isActive.toString().contains('0')){
                      return Container();
                    }
                    else{
                      return buildProduct(size, controller.products[index]);
                    }
                  }
                },
              );
            }
          }),
          onRefresh: () async {
            searchController.clear();
            searchMethod();
          },
        ),
      ),
      floatingActionButton: buildFloatingButton(context),
    );
  }

  Widget buildScanner(Size size){
    return InkWell(
      onTap: (){
        scanBarcode();
      },
      child: Image.asset('assets/icons/barcode_reader.png', color: Colors.white,)
    );
  }

  void scanBarcode() async {
    late String scanResult_;
    try {
      scanResult_ = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult_ = 'Failed to scan';
    }
    if (!mounted) {
      return;
    }

    setState(() {

      //to search product by product code
      //searchMethod(searchString: scanResult_);
      ///if barcode scanner is canceled then result is -1 so I ignore this result
      if(scanResult_!='-1'){
        scanResult = scanResult_;
        searchController.text=scanResult.toString();
      }
    });

    print(scanResult);
  }

  Widget buildProduct(Size size, ProductData product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: (){
            buildBottomSheet(size, context, product);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.05)
            ),
            child: Row(
              children: [
                Container(
                  width: size.height/8,
                  height: size.height/8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: '${product.avatar}',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: AutoSizeText('${product.name}', maxLines: 3,),
                    subtitle: AutoSizeText('${AppLocalizations.of(context)!.stock} : ${product.qty} ${product.stock!.last.unit}', maxLines: 1,),
                    trailing: AutoSizeText('${product.stock!.last.price} $currency',
                        style: TextStyle(fontSize: 16, color: mainColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFloatingButton(BuildContext context){
    return CustomBadge(
        value: '$cartItemLength',
        right: 10,
        top: 10,
        child: FloatingActionButton(
          heroTag: 'btn1',
          onPressed: ()async{
            await Get.toNamed(RouteGenerator.cartScreen);
            getCartData();
          },
          child: Icon(Icons.shopping_cart, color: myWhite,),
          backgroundColor: mainColor,
          elevation: 0,
      )
    );
  }

  Future buildBottomSheet(Size size, BuildContext context, ProductData product){

    List<ProductStock>? stockList = product.stock;

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

    int quantity=1;
    int max_quantity=int.parse(product.qty.toString());
    quantityController.text='1';
    var selectedUnit = stockList.last.unit;
    double productPrice = double.parse(stockList.last.price.toString());
    int stock=int.parse(product.qty.toString());
    int totalStock=int.parse(product.qty.toString());

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.only(top: 16),
                height: size.height*0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///items info section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            height: size.height*0.2,
                            width: size.height*0.2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(4),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider('${product.avatar}')
                              )
                            ),
                          ),
                          SizedBox(width: size.width*0.05,),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$productPrice $currency',style: TextStyle(fontSize: 20,color: mainColor, fontWeight: FontWeight.w700)),
                                SizedBox(height: size.height*0.03,),
                                Text('${product.name}',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                SizedBox(height: size.height*0.01,),
                                Text('${AppLocalizations.of(context)!.stock} : $stock $selectedUnit'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height*0.01,),

                  ///unit section
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text('${AppLocalizations.of(context)!.unit}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          SizedBox(width: size.width*0.05,),
                          Expanded(
                            child: Container(
                              height: size.height*0.06,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: const Icon(Icons.keyboard_arrow_down),
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

                                        }
                                      });
                                    },
                                    items: unitTypes.map<DropdownMenuItem<String>>((String val){
                                      return DropdownMenuItem(
                                        child: Text(val,style: const TextStyle(color: Colors.black),),
                                        value: val,
                                      );
                                    }).toList(),
                                    dropdownColor: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height*0.02,),

                    ///quantity section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text('${AppLocalizations.of(context)!.quantity}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          SizedBox(width: size.width*0.05,),
                          Expanded(
                            child: Row(
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
                                        setState(() {
                                          quantity=int.parse(quantityController.text.toString());
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),

                    ///add to cart button
                    Spacer(),
                    myButton(
                        onTap: ()async{

                          //clear cartList to store again with new
                          cartList=[];

                          //clear searchController
                          searchController.clear();

                          int qty=int.parse(quantityController.text.toString());
                          if(qty>max_quantity){
                            showToastMessage(AppLocalizations.of(context)!.bigQuantityMsg);
                          }
                          else{
                            await getCartData().then((value){
                              cartList.add(
                                  CartData(
                                    product.id,
                                    product.name,
                                    product.brand,
                                    product.code,
                                    product.avatar,
                                    product.tax.toString(),
                                    product.qty,
                                    productPrice.toString(),
                                    selectedUnit,
                                    quantity,
                                    max_quantity,
                                    stockList,
                                  ));
                            });

                            addCartDataInLocale(cartList);


                            getCartData();

                            print('hi');

                            showToastMessage('Product added to cart');
                            Navigator.pop(context);
                          }
                        },
                        buttonText: AppLocalizations.of(context)!.addToCart,
                        paddingHorizontal: 16
                    ),
                    SizedBox(height: size.height*0.03,),


                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> addCartDataInLocale(List<CartData> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cartList', jsonEncode(list));
  }

  Future<void> getCartData() async {
    cartItemLength=0;
    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> jsonData =
    jsonDecode(prefs.getString('cartList') ?? '[]');
    var cartList_ = jsonData.map<CartData>((jsonItem) {
      print(jsonItem);
      cartItemLength++;
      return CartData.fromJson(jsonItem);
    }).toList();
    setState(() {});

    cartList.addAll(cartList_);
    print(cartList.length);
  }

}

class RefreshSalesScreen{
  void refresh(){
    SalesScreen salesScreen=SalesScreen();
    salesScreen.productController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
    salesScreen.productController.products.value=[];    //set product list empty
    salesScreen.productController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
    salesScreen.productController.getData();
  }
}
