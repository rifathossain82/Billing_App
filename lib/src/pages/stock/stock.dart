import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/productController.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constaints/colors/AppColors.dart';
import '../../controller/currencyController.dart';
import '../../model/productData.dart';
import '../../widgets/appBar_bg.dart';
import '../../widgets/decoration/searchTextFieldDecoration_.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {

  final productController=Get.put(ProductController());
  TextEditingController searchController=TextEditingController();
  var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

  ScrollController _scrollController = ScrollController();
  var pageNumber=Get.find<ProductController>().pageNumber;

  var scanResult;

  @override
  void initState() {
    scrollIndicator();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  searchMethod(){
    print(searchController.text.toString());

    if(searchController.text.toString().isEmpty){
      productController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
      productController.products.value=[];    //set product list empty
      productController.totalStock=0;    //set total stock is 0
      productController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
      productController.getData();
    }
    else{
      productController.getData(name: searchController.text.toString());
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
            ++productController.pageNumber.value;
            productController.getData();
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
        title: Text(AppLocalizations.of(context)!.stock+" "+AppLocalizations.of(context)!.list),
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
              return Column(
                children: [

                  //build product list
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
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
                    ),
                  ),

                  //stock amount
                  buildStockAmount(size, controller.totalStock.toString()),
                ],
              );
            }
          }),
          onRefresh: () async {
            searchController.clear();
            searchMethod();
          },
        ),
      ),
    );
  }

  Widget buildProduct(Size size, ProductData product) {

    //set product unit
    var productUnit = product.stock!.last.unit;
    int quantity=int.parse(product.qty.toString());
    double price=double.parse(product.stock!.last.price.toString());
    double totalPrice=quantity * price;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText('${AppLocalizations.of(context)!.price} : ${price} $currency', maxLines: 1,),
                     AutoSizeText('${AppLocalizations.of(context)!.stock} : ${product.qty} ${productUnit}', maxLines: 1,),
                    ],
                  ),
                  trailing: AutoSizeText('${totalPrice} ${currency}',),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget buildStockAmount(Size size, String amount){
    return Container(
      //height: size.height * 0.08,
      width: size.width,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${AppLocalizations.of(context)!.stock}-',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            '${amount} $currency',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
