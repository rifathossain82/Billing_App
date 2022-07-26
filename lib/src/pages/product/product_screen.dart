import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/controller/currencyController.dart';
import 'package:billing_app/src/controller/productController.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../constaints/util/util.dart';
import '../../controller/tokenController.dart';
import '../../model/productData.dart';
import '../../widgets/appBar_bg.dart';
import '../../widgets/decoration/searchTextFieldDecoration_.dart';


class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key}) : super(key: key);

  final productController=Get.put(ProductController());

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  TextEditingController searchController = TextEditingController();
  var tokenController=Get.find<TokenController>();
  var currency=Get.find<CurrencyController>().currency;

  ScrollController _scrollController = ScrollController();
  var pageNumber=Get.find<ProductController>().pageNumber;

  //to store bar code scan result
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

  void searchMethod(){
    print(searchController.text.toString());

    if(searchController.text.toString().isEmpty){
      RefreshProductScreen().refresh();
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.products,),
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
                    decoration: searchTextFieldDecoration_(
                        AppLocalizations.of(context)!.search,
                        searchController,
                        searchMethod
                    ),
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
                    return buildProduct(size, controller.products[index]);
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

  Widget buildProduct(Size size, ProductData product) {

    // //set product unit
    // var productUnit;
    // if(product.stock!.unit == 'null' || product.stock!.unit == null){
    //   productUnit=product.stock?.baseUnit;
    // }
    // else{
    //   productUnit=product.stock?.unit;
    // }

    //by default we set status active and statusColor is successColor
    var status='Active';
    var statusColor=successColor;

    //set status and status color
    if(product.isActive.toString().contains('0')){
      status='Inactive';
      statusColor=failedColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: (){
            Get.toNamed(RouteGenerator.detailsProduct, arguments: '${product.id}');
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.05)
            ),
            child: Row(
              children: [
                Hero(
                  tag: '${product.id}',
                  child: Container(
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
                ),
                Expanded(
                  child: ListTile(
                    title: AutoSizeText('${product.name}', maxLines: 3,),
                    subtitle: AutoSizeText('${AppLocalizations.of(context)!.stock} : ${product.qty} ${product.stock!.last.unit}', maxLines: 1,),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AutoSizeText('${status}', style: TextStyle(color: statusColor),),
                        AutoSizeText(
                          '${product.stock!.last.price} ${currency}',
                          style: TextStyle(fontSize: 16, color: statusColor)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
      if(scanResult_ != '-1'){
        scanResult = scanResult_;
        searchController.text=scanResult.toString();
      }
    });

    print(scanResult);
  }

  Widget buildFloatingButton(BuildContext context){
    return FloatingActionButton(
      onPressed: (){
        Get.toNamed(RouteGenerator.addProduct);
      },
      child: Icon(Icons.add,color: myWhite,),
      backgroundColor: mainColor,
      elevation: 0,
    );
  }


}

class RefreshProductScreen{
  void refresh(){
    final productScreen=ProductScreen();
    productScreen.productController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
    productScreen.productController.products.value=[];    //set product list empty
    productScreen.productController.isLoading(true);      //set loading true as a result we can show a loader when we will refresh
    productScreen.productController.getData();            //call api to load all product
  }
}
