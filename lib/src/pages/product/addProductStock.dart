import 'package:billing_app/src/widgets/customScrollBehavior/myBehavior.dart';
import 'package:flutter/material.dart';

class AddProductStock extends StatefulWidget {
  const AddProductStock({Key? key}) : super(key: key);

  @override
  State<AddProductStock> createState() => _AddProductStockState();
}

class _AddProductStockState extends State<AddProductStock> {

  List<TextEditingController> unitQuantityController=[];
  List<TextEditingController> unitNameController=[];

  @override
  void initState() {
    unitQuantityController.add(TextEditingController());
    unitNameController.add(TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Stock'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProductStockRow(title: 'Base Unit', unitNameController: unitQuantityController[0], unitQuantityController: unitNameController[0])
            ],
          ),
        ),
      ),
    );
  }
}

class ProductStockRow extends StatelessWidget {
  ProductStockRow({Key? key,
    required this.title,
    required this.unitNameController,
    required this.unitQuantityController}) : super(key: key);

  String title;
  TextEditingController unitQuantityController;
  TextEditingController unitNameController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$title',
                  maxLines: 1,
                ),
              ),
              Text(
                '=',

              ),
            ],
          ),
        ),
        SizedBox(width: 12,),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: unitQuantityController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '10',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: TextField(
                  controller: unitNameController,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Box',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


