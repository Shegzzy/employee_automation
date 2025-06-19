import 'package:flutter/material.dart';
import 'package:mobile_assessment/modules/widgets/employee_card/employee_card.dart';
import 'package:mobile_assessment/service/providers/employees_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<EmployeeProvider>(context, listen: false);
      viewModel.loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees Productivity'), centerTitle: true,),
      body: Consumer<EmployeeProvider>(
        builder: (context, emProvider, child) {
          return ListView.builder(
            itemCount: emProvider.employees.length,
            itemBuilder: (context, index) {
              final employee = emProvider.employees[index];
              return EmployeeCard(
              child: Column(
                children: [
                  Text(employee.firstName)
                ],
              )
            );
          });
      }),
    );
  }
}
