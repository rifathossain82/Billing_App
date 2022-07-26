import 'dart:io';
import 'package:billing_app/src/model/customerData.dart';
import 'package:billing_app/src/services/api/pdf_api/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../constaints/util/util.dart';
import '../../../controller/currencyController.dart';
import '../../../model/invoice.dart';


class PdfInvoiceApi {

  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

     final  font = await rootBundle.load("assets/fonts/NotoSerifBengali.ttf");
     final  ttf = Font.ttf(font);
    
    pdf.addPage(MultiPage(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (context)=>[
        buildHeader(invoice),
        SizedBox(height: 1*PdfPageFormat.cm),
        buildTitle(invoice),
        SizedBox(height: 1*PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context)=> buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: invoice.info.number.toString()+".pdf", pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildSellerAddress(invoice.seller),
                Container(
                  height: 50,
                  width: 50,
                  child: BarcodeWidget(
                      data: invoice.info.number,
                      barcode: Barcode.fromType(BarcodeType.QrCode)
                  )
                )
              ]
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildCustomerAddress(invoice.customerData),
                buildInvoiceInfo(invoice.info),
              ]
          ),
        ]
    );
  }

  static Widget buildSellerAddress(Seller seller){
    var sellerMobileNo='${seller.countryCode ?? ''}${seller.phone!}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: seller.name!,
                style: TextStyle(fontWeight: FontWeight.bold)
              ),
              TextSpan(
                text: ' (Seller)',
                style: TextStyle(fontWeight: FontWeight.normal,)
              )
            ]
          )
        ),
        SizedBox(height: 1*PdfPageFormat.mm),
        Text('$sellerMobileNo'),

      ]
    );
  }

  static Widget buildCustomerAddress(CustomerData customer){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: customer.name!,
                        style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                        text: ' (Customer)',
                        style: TextStyle(fontWeight: FontWeight.normal,)
                    )
                  ]
              )
          ),
          //Text('${customer.name}', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1*PdfPageFormat.mm),
          Text('${customer.phone}'),
          //SizedBox(height: 1*PdfPageFormat.mm),
          //Text('${customer.email}'),
          //SizedBox(height: 1*PdfPageFormat.mm),
          //Text('${customer.address}'),

        ]
    );
  }

  static Widget buildInvoiceInfo(InvoiceInfo info){
    final paymentTerms= '${info.date.year} - ${info.date.month} - ${info.date.day}';
    final titles=[
      'Invoice Number:',
      'Invoice Date:',
      //'Payment Terms:',
    ];

    final data=[
      info.number,
      Util.formatDate(info.date),
      // paymentTerms,
    ];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(titles.length, (index){
          final title=titles[index];
          final value=data[index];

          return buildText(title: title, value: value, width: 200);
        })
    );
  }

  static Widget buildTitle(Invoice invoice){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${invoice.info.businessName}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
        SizedBox(height: 0.3*PdfPageFormat.cm),
        Text('Address: ${invoice.info.address}'),
        Text('Phone: ${invoice.info.countryCode}${invoice.info.mobile}'),
      ]
    );
  }

  static Widget buildInvoice(Invoice invoice){

    var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

    final headers=[
      'Product',
      'Quantity',
      'Unit Price',
      'Tax',
      'Total'
    ];

    final data=invoice.items.map((item){

      //find total amount per product
      double totalPrice=item.total!;
      double tax=item.tax!;

      double taxAmount=(totalPrice*tax)/100;
      double totalAmount=totalPrice+taxAmount;

      return [
        item.productName,
        '${item.qty} ${item.unit}',
        '${item.unitPrice} $currency',
        '${item.tax} %',
        '${totalAmount} $currency',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
      }
    );
  }

  static Widget buildTotal(Invoice invoice){

    var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

    double total=0;   //to store total price without vat , tax
    double taxAmount=0;     //to store total tax amount
    double totalWithTax=0;     //to store total price with tax
    double totalAmount=0;     //to store total amount of invoice

    for(int i=0; i<invoice.items.length; i++){
      total=total+invoice.items[i].total!;
      taxAmount=taxAmount+(invoice.items[i].total!*invoice.items[i].tax!)/100;
    }
    totalWithTax=total+taxAmount;
    totalAmount=totalWithTax-invoice.info.discount;



    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(title: 'Net Total', value: '${Util.formatPrice(total)} $currency', unite: true),
                buildText(title: 'Tax Amount', value: '${Util.formatPrice(taxAmount)} $currency', unite: true),
                Divider(),
                buildText(title: 'Total (Incl Tax)', value: '${Util.formatPrice(totalWithTax)} $currency', unite: true),
                buildText(title: 'Discount', value: '${Util.formatPrice(invoice.info.discount)} $currency', unite: true),
                Divider(),
                buildText(
                    title: 'Total Amount',
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                    value: '${Util.formatPrice(totalAmount)} $currency',
                    unite: true
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ]
            ),

          ),

        ]
      )
    );
  }

  static buildText({
    required String title,
    required String value,
    double width =double.infinity,
    TextStyle? titleStyle,
    bool unite= false,
    }){
        final style=titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

        return Container(
          width: width,
          child: Row(
            children: [
              Expanded(child: Text(title, style: style)),
              Text(value, style: unite ? style : null),
            ]
          )
        );
    }

    static Widget buildFooter(Invoice invoice){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2*PdfPageFormat.mm),
          buildSimpleText(title: 'Operation & Maintenance by- ', value: 'Web Point Ltd.'),
          SizedBox(height: 1*PdfPageFormat.mm),
          //buildSimpleText(title: 'Paypal', value: invoice.supplierData.paymentInfo)
        ]
      );
    }

    static buildSimpleText({
      required String title,
      required String value,
    }){
        final style=TextStyle(fontWeight: FontWeight.bold);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            SizedBox(width: 2*PdfPageFormat.mm),
            Text(value, style: style),
          ]
        );
    }

}


/*
import 'dart:io';
import 'package:billing_app/src/model/customerData.dart';
import 'package:billing_app/src/model/supplierData.dart';
import 'package:billing_app/src/services/api/pdf_api/pdf_api.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../constaints/util/util.dart';
import '../../../controller/currencyController.dart';
import '../../../model/invoicePage.dart';


class PdfInvoiceApi {

  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (context)=>[
        buildHeader(invoice),
        SizedBox(height: 3*PdfPageFormat.cm),
        buildTitle(invoice),
        SizedBox(height: 1*PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context)=> buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: invoice.info.number.toString()+".pdf", pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildSupplierAddress(invoice.seller),
            // Container(
            //   height: 50,
            //   width: 50,
            //   child: BarcodeWidget(
            //       data: invoice.info.number,
            //       barcode: Barcode.fromType(BarcodeType.QrCode)
            //   )
            // )
          ]
        ),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildCustomerAddress(invoice.customerData),
              buildInvoiceInfo(invoice.info),
            ]
        ),
      ]
    );
  }

  static Widget buildSupplierAddress(Seller seller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(seller.name!, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 1*PdfPageFormat.mm),
        Text(seller.phone!),

      ]
    );
  }

  static Widget buildCustomerAddress(CustomerData customer){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${customer.name}', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1*PdfPageFormat.mm),
          Text('${customer.phone}'),
          //SizedBox(height: 1*PdfPageFormat.mm),
          //Text('${customer.email}'),
          //SizedBox(height: 1*PdfPageFormat.mm),
          //Text('${customer.address}'),

        ]
    );
  }

  static Widget buildInvoiceInfo(InvoiceInfo info){
    final paymentTerms= '${info.date.year} - ${info.date.month} - ${info.date.day}';
    final titles=[
      'Invoice Number:',
      'Invoice Date:',
      //'Payment Terms:',
    ];

    final data=[
      info.number,
      Util.formatDate(info.date),
     // paymentTerms,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index){
        final title=titles[index];
        final value=data[index];

        return buildText(title: title, value: value, width: 200);
      })
    );
  }

  static Widget buildTitle(Invoice invoice){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${invoice.info.businessName}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
        SizedBox(height: 0.3*PdfPageFormat.cm),
        Text(invoice.info.mobile),
      ]
    );
  }

  static Widget buildInvoice(Invoice invoice){

    var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

    final headers=[
      'Product',
      'Quantity',
      'Unit Price',
      'Tax',
      'Total'
    ];

    final data=invoice.items.map((item){

      //find total amount per product
      double totalPrice=item.total!;
      double tax=item.tax!;

      double taxAmount=(totalPrice*tax)/100;
      double totalAmount=totalPrice+taxAmount;

      return [
        item.name,
        '${item.qty}',
        '${item.unit_price} $currency',
        '${item.tax} %',
        '${totalAmount} $currency',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
      }
    );
  }

  static Widget buildTotal(Invoice invoice){

    var currency=Get.find<CurrencyController>().currency.value;   //get currency from controller

    double total=0;   //to store total price without vat , tax
    double taxAmount=0;     //to store total tax amount
    double totalWithTax=0;     //to store total price with tax
    double totalAmount=0;     //to store total amount of invoice

    for(int i=0; i<invoice.items.length; i++){
      total=total+invoice.items[i].total!;
      taxAmount=taxAmount+(invoice.items[i].total!*invoice.items[i].tax!)/100;
    }
    totalWithTax=total+taxAmount;
    totalAmount=totalWithTax-invoice.info.discount;



    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(title: 'Net Total', value: '${Util.formatPrice(total)} $currency', unite: true),
                buildText(title: 'Tax Amount', value: '${Util.formatPrice(taxAmount)} $currency', unite: true),
                Divider(),
                buildText(title: 'Total (Incl Tax)', value: '${Util.formatPrice(totalWithTax)} $currency', unite: true),
                buildText(title: 'Discount', value: '${Util.formatPrice(invoice.info.discount)} $currency', unite: true),
                Divider(),
                buildText(
                    title: 'Total Amount',
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                    value: '${Util.formatPrice(totalAmount)} $currency',
                    unite: true
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ]
            ),

          ),

        ]
      )
    );
  }

  static buildText({
    required String title,
    required String value,
    double width =double.infinity,
    TextStyle? titleStyle,
    bool unite= false,
    }){
        final style=titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

        return Container(
          width: width,
          child: Row(
            children: [
              Expanded(child: Text(title, style: style)),
              Text(value, style: unite ? style : null),
            ]
          )
        );
    }

    static Widget buildFooter(Invoice invoice){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2*PdfPageFormat.mm),
          buildSimpleText(title: 'Operation & Maintenance by- ', value: 'Web Point Ltd.'),
          SizedBox(height: 1*PdfPageFormat.mm),
          //buildSimpleText(title: 'Paypal', value: invoice.supplierData.paymentInfo)
        ]
      );
    }

    static buildSimpleText({
      required String title,
      required String value,
    }){
        final style=TextStyle(fontWeight: FontWeight.bold);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            SizedBox(width: 2*PdfPageFormat.mm),
            Text(value, style: style),
          ]
        );
    }

}
 */