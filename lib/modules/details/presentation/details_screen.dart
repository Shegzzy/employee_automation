import 'package:flutter/material.dart';
import 'package:mobile_assessment/models/employee_model.dart';

class DetailsScreen extends StatefulWidget {
  final Employee employee;
  const DetailsScreen({Key? key, required this.employee}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Details'), centerTitle: true,),

    );
  }
}
