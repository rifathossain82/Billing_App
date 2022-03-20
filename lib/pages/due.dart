import 'package:flutter/material.dart';

class Due extends StatefulWidget {
  const Due({Key? key}) : super(key: key);

  @override
  State<Due> createState() => _DueState();
}

class _DueState extends State<Due> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Due List'),
      ),
    );
  }
}
