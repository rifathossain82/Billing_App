import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/src/constaints/util/util.dart';
import 'package:billing_app/src/controller/authenticationController.dart';
import 'package:billing_app/src/controller/invoiceController.dart';
import 'package:billing_app/src/model/DateModel.dart';
import 'package:billing_app/src/model/customerData.dart';
import 'package:billing_app/src/model/invoiceData.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/decoration/searchTextFieldDecoration_.dart';
import 'package:billing_app/src/widgets/showNoItem.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/routes.dart';
import '../../constaints/colors/AppColors.dart';
import '../../model/invoice.dart';
import '../../services/api/pdf_api/pdf_api.dart';
import '../../services/api/pdf_api/pdf_invoice_api.dart';
import '../../widgets/appBar_bg.dart';
import '../../widgets/decoration/dateTextFieldDecoration.dart';
import '../../widgets/myButton.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {

  TextEditingController searchController=TextEditingController();
  TextEditingController customerController=TextEditingController();
  TextEditingController fromDateController=TextEditingController();
  TextEditingController toDateController=TextEditingController();

  ScrollController _scrollController=ScrollController();

  //to fetch invoice data
  final invoiceController=Get.put(InvoiceController());
  var scanResult;   //to store scan result

  //to select customer and store , id for search
  var customerName;
  var customerId;

  late DateTime date1;    //to store from or start date
  late DateTime date2;    //to store to or end date

  //to search by date I use this variable
  DateModel _dateModel=DateModel();

  @override
  void initState() {

    scrollIndicator();

    //to set current date
    setCurrentDate();

    super.initState();
  }

  @override
  void dispose(){
    searchController.dispose();
    customerController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollIndicator(){
    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange){
        print("Reach the bottom");
        if(!Get.find<InvoiceController>().loadedCompleted.value){
          ++invoiceController.pageNumber.value;
          invoiceController.getData(dateModel: DateModel());
        }
      }
    });
  }

  //set current date
  setCurrentDate(){
    date1=DateTime.now();
    date2=DateTime.now();

    //set also texField
    fromDateController.text='${date1.day} - ${date1.month} - ${date1.year}';
    toDateController.text='${date2.day} - ${date2.month} - ${date2.year}';
  }

  searchMethod(){
    print(searchController.text.toString());

    if(searchController.text.toString().isNotEmpty){
      print("1");
      customerId=null;
      _dateModel=DateModel();
      invoiceController.getData(invNumber: searchController.text.toString());
    }
    else if(customerId!=null && _dateModel.startDate.toString().contains('null')){
      print("2");
      print(customerId);
      invoiceController.getData(customerId: customerId);
    }
    else if(!_dateModel.startDate.toString().contains('null') && customerId==null){
      print("3");
      print(_dateModel.startDate.toString());
      invoiceController.getData(dateModel: _dateModel);
    }
    else if(!_dateModel.startDate.toString().contains('null') && customerId!=null){
      print("4");
      invoiceController.getData(dateModel: _dateModel, customerId: customerId);
    }
    else{
      print('5');
      refreshPage();
    }
  }

  void refreshPage(){
    //if we refresh then everything is set newly
    customerId=null;
    _dateModel=DateModel();
    setCurrentDate();
    setState(() {
      customerName=AppLocalizations.of(context)!.selectCustomer;
    });

    invoiceController.pageNumber.value=1;   //set page number 1 when we refresh or search without any text
    invoiceController.invoices.value=[];    //set invoice list empty
    invoiceController.isLoading(true);
    invoiceController.getData(dateModel: _dateModel);
  }

  @override
  void didChangeDependencies() {
    ///to load localizations text
    if(customerName.toString().isEmpty || customerName==null){
      customerName=AppLocalizations.of(context)!.selectCustomer;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myWhite.withOpacity(0.95),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.invoice+" "+AppLocalizations.of(context)!.list),
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
                    keyboardType: TextInputType.number,
                    decoration: searchTextFieldDecoration_(AppLocalizations.of(context)!.invoiceNumber, searchController, searchMethod),
                  ),
                ),
                SizedBox(width: size.width*0.02,),
                Expanded(
                    flex: 1,
                    child: buildScanner(size)
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(onPressed: () {
                    Util.hideKeyboard(context);
                    buildBottomSheet(size);
                  }, icon: Icon(Icons.filter_list, color: myWhite,size: 40,)),
                )
              ],
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: RefreshIndicator(
            child: GetX<InvoiceController>(builder: (controller){
              if(controller.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(controller.isLoading.value==false && controller.invoices.isEmpty){
                return Stack(
                  children: [
                    ListView(),
                    Center(
                      child: ShowNoItem(title: AppLocalizations.of(context)!.noDataFound),
                    ),
                  ],
                );
              }
              else{
                return ListView.builder(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: controller.invoices.length+1,
                  itemBuilder: (context, index){
                    if(index==controller.invoices.length &&
                        !Get.find<InvoiceController>().loadedCompleted.value){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(index==controller.invoices.length &&
                        Get.find<InvoiceController>().loadedCompleted.value){
                      return Container();
                    }
                    else{
                      return buildInvoice(size, controller.invoices[index]);
                    }
                  },
                );
              }
            }),
            onRefresh: ()async{
              searchController.clear();
              refreshPage();
            },
          )
      ),

    );
  }

  Widget buildInvoice(Size size, InvoiceData invoiceData){

    //to show date
    DateTime date=DateTime.parse(invoiceData.date.toString());
    var newDate='${date.year}-${date.month}-${date.day}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
      child: Card(
        elevation: 0,
        child: ListTile(
          onTap: ()async{
            await createInvoice(invoiceData);
          },
          leading: const Icon(Icons.picture_as_pdf_outlined),
          title: AutoSizeText('${invoiceData.invoiceNo}.pdf', style: TextStyle(), maxLines: 1,),
          subtitle: Text('${invoiceData.total} '),    //${invoiceData.invoiceProduct![0].unit}
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${newDate}',style: TextStyle(fontSize: 16,color: mainColor)),
              Text('${invoiceData.customer!.name}',style: TextStyle(fontSize: 12,color: mainColor)),
            ],
          ),
        ),
      ),
    );
  }

  //to generate invoice based on data
  Future<void> createInvoice(InvoiceData invoiceData)async{

    try{

      //find company
      var company=Get.find<AuthenticationController>().user[0].company;

      //to convert date and discount amount
      DateTime date=DateTime.parse(invoiceData.date.toString());
      double discount=double.parse(invoiceData.discount.toString());

      //set invoice info
      final invoiceInfo=InvoiceInfo(
          date: date,
          businessName: '${company!.name}',
          email: '${company.email}',
          countryCode: '${company.countryCode}',
          mobile: '${company.mobile}',
          address: '${company.address}',
          number: '${invoiceData.invoiceNo}',
          discount: discount
      );

      //set seller info
      final seller=Seller(
        id: invoiceData.user!.id.toString(),
        name: invoiceData.user!.name.toString(),
        phone: invoiceData.user!.mobile.toString(),
      );

      //set customer data
      CustomerData customer=CustomerData(
        id: invoiceData.customer!.id,
        name: invoiceData.customer!.name,
        phone: invoiceData.customer!.phone,
      );

      //to store invoice item
      List<InvoiceItem> invoiceItemList=[];

      //to create we need invoice item so we invoice product to invoiceItem
      if(invoiceData.invoiceProduct!=null){
        for(int i=0; i!=invoiceData.invoiceProduct!.length; i++){
          InvoiceItem item=InvoiceItem(
            productName: invoiceData.invoiceProduct![i].productName,
            qty: invoiceData.invoiceProduct![i].qty,
            unit: invoiceData.invoiceProduct![i].unit,
            unitPrice: double.parse(invoiceData.invoiceProduct![i].unitPrice.toString()),
            discount: invoiceData.invoiceProduct![i].discount,
            vat: double.parse(invoiceData.invoiceProduct![i].vat.toString()),
            tax: double.parse(invoiceData.invoiceProduct![i].tax.toString()),
            total: double.parse(invoiceData.invoiceProduct![i].total.toString()),
          );

          invoiceItemList.add(item);
        }
      }

      //set invoice info
      final invoice=Invoice(
          info: invoiceInfo,
          seller: seller,
          customerData: customer,
          items: invoiceItemList
      );

      //generate pdf file
      final pdfFile=await PdfInvoiceApi.generate(invoice);

      print('my pdf file location $pdfFile');

      //open pdf file
      PdfApi.openFile(pdfFile);
    }catch(e){
      print(e);
      showToastMessage('Unable to load invoice');
    }

  }

  ///to build scanner
  Widget buildScanner(Size size){
    return InkWell(
        onTap: (){
          Util.hideKeyboard(context);
          scanBarcode();
        },
        child: Image.asset('assets/icons/barcode_reader.png', color: Colors.white,)
    );
  }

  ///to scan barcode
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


  ///to filter list invoice
  Future buildBottomSheet(Size size){
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSelectCustomer(size),
            SizedBox(height: size.height*0.03,),
            buildDate(size),
            SizedBox(height: size.height*0.05,),
            myButton(
              onTap: (){
                searchController.clear(); //to search only customer and date wise
                searchMethod();
                Navigator.pop(context);
                },
              buttonText: AppLocalizations.of(context)!.ok,
              paddingHorizontal: 16,
              fontWeight: FontWeight.w700,
            ),
          ],
        );
      },
    );
  }

  ///to search invoice order by customer
  Widget buildSelectCustomer(Size size){

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: ()async{
              CustomerData result=await Get.toNamed(RouteGenerator.selectCustomer);

              setState(() {
                if(result.id!=null){
                  customerName=result.name.toString();
                  customerId=result.id.toString();
                }
              });
            },
            borderRadius: BorderRadius.circular(4),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: textColor2.withOpacity(0.3))
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
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
          ),
        );
      }
    );
  }

  ///to search invoice order by date
  Widget buildDate(Size size){

    return SizedBox(
      width: size.width,
      height: size.height*0.1,
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: ()async{
                      DateTime? newDate1=await showDatePicker(
                          context: context,
                          initialDate: date1,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100)
                      );

                      if(newDate1==null) return;
                      setState(() {
                        date1=newDate1;
                        fromDateController.text='${date1.day} - ${date1.month} - ${date1.year}';

                        setDate();
                      });
                    },
                    controller: fromDateController,
                    readOnly: true,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.black54),
                    decoration: dateTextFieldDecoration(AppLocalizations.of(context)!.fromDate),
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: ()async{
                      DateTime? newDate1=await showDatePicker(
                          context: context,
                          initialDate: date2,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100)
                      );

                      if(newDate1==null) return;
                      setState(() {
                        date2=newDate1;
                        toDateController.text='${date2.day} - ${date2.month} - ${date2.year}';

                        setDate();
                      });
                    },
                    controller: toDateController,
                    readOnly: true,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.black54),
                    decoration: dateTextFieldDecoration(AppLocalizations.of(context)!.toDate),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //to search we need formatted date that's why I use this method
  setDate(){
    DateFormat format=DateFormat('yyyy-MM-dd');
    var start=format.format(date1);
    var end=format.format(date2);
    print(start);
    print(FontAwesomeIcons.e);
    _dateModel=DateModel(startDate: start, endDate: end);
  }


}


/*

import 'package:billing_app/src/model/invoicePdf.dart';
import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:billing_app/src/widgets/myAlertDialog.dart';
import 'package:billing_app/src/widgets/showToastMessage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/appBar_bg.dart';
import '../../widgets/decoration/searchTextFieldDecoration.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {

  late SharedPreferences sharedPreferences;
  // this two list for fetch invoice url and name form sharedPreferences
  List<String> urlList=[];
  List<String> nameList=[];

  // this 1st list for store invoice data as model class
  // this 2nd list for search invoice data
  List<InvoicePdf> invoicePdfList=[];
  List<InvoicePdf> invoicePdfList2=[];

  void getFileName() async {
    urlList=[];
    nameList=[];
    invoicePdfList=[];
    invoicePdfList2=[];

    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      urlList = sharedPreferences.getStringList('invoiceUrlList')!;
      nameList = sharedPreferences.getStringList('invoiceNameList')!;
    });

    for(int i=0; i<urlList.length; i++){
      invoicePdfList.add(InvoicePdf(nameList[i], urlList[i]));
      invoicePdfList2.add(InvoicePdf(nameList[i], urlList[i]));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFileName();
  }

  TextEditingController searchController=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.invoice+" "+AppLocalizations.of(context)!.list),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: AppBar_bg(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
            child: TextField(
              controller: searchController,
              onChanged: searchInvoicePdf,
              decoration: searchTextFieldDecoration(AppLocalizations.of(context)!.invoiceNumber),
            ),
          ),
        ),
        actions: [
          invoicePdfList.isEmpty?
          Center()
              :
          GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (BuildContext context){
                return myAlertDialog(
                    AppLocalizations.of(context)!.warning+"!!",
                    AppLocalizations.of(context)!.deleteMsg,
                    AppLocalizations.of(context)!.cancel,
                    AppLocalizations.of(context)!.delete, () {
                  deleteAllInvoice();
                  Navigator.pop(context);
                  getFileName();
                  showToastMessage(AppLocalizations.of(context)!.deleteSuccessful);
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
              child: Text(AppLocalizations.of(context)!.deleteAll),
            ),
          )
        ],
      ),
      body: invoicePdfList.isEmpty?
      Center(child: Text(AppLocalizations.of(context)!.noInvoiceYet))
          :
      ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: invoicePdfList.length,
          itemBuilder: (context, index){
            return Column(
              children: [
                ListTile(
                  onTap: ()async{
                    await OpenFile.open(invoicePdfList[index].url);
                  },
                  leading: Icon(Icons.picture_as_pdf_outlined),
                  title: Text(invoicePdfList[index].name),
                  trailing: IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return myAlertDialog(
                            AppLocalizations.of(context)!.warning+"!!",
                            AppLocalizations.of(context)!.deleteMsg,
                            AppLocalizations.of(context)!.cancel,
                            AppLocalizations.of(context)!.delete, () {
                          deleteSingleInvoice(invoicePdfList[index].url, invoicePdfList[index].name);
                          Navigator.pop(context);
                          getFileName();
                          showToastMessage(AppLocalizations.of(context)!.deleteSuccessful);
                        });
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
                Divider(height: 1,),
              ],
            );
          },
        ),
      ),
    );
  }

  void searchInvoicePdf(String query){
    final suggestions=invoicePdfList2.where((invoicePdf){
      final invoiceName=invoicePdf.name.toLowerCase();
      final input=query.toLowerCase();

      return invoiceName.contains(input);
    }).toList();

    setState(() {
      invoicePdfList=suggestions;
    });
  }

  void deleteAllInvoice()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('invoiceUrlList', []);
    sharedPreferences.setStringList('invoiceNameList', []);
  }

  void deleteSingleInvoice(String url, String name)async{

    ///to store new list without specific invoice
    List<String> invoiceUrlList=[];
    List<String> invoiceNameList=[];


    for(int i=0; i<urlList.length; i++){
      if(urlList[i].contains(url)){

      }
      else{
        invoiceUrlList.add(urlList[i]);
        invoiceNameList.add(nameList[i]);
      }
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('invoiceUrlList', invoiceUrlList);
    sharedPreferences.setStringList('invoiceNameList', invoiceNameList);
  }
}

 */
