import 'package:flutter/material.dart';

class PublicVendors extends StatefulWidget {
  const PublicVendors({Key? key}) : super(key: key);

  @override
  State<PublicVendors> createState() => _PublicVendorsState();
}

class _PublicVendorsState extends State<PublicVendors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Vendors'),
      ),
    );
  }
}
