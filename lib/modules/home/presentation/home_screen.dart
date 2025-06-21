import 'package:flutter/material.dart';
import 'package:mobile_assessment/common/colors.dart';
import 'package:mobile_assessment/common/sizes.dart';
import 'package:mobile_assessment/modules/details/presentation/details_screen.dart';
import 'package:mobile_assessment/modules/widgets/employee_card/employee_card.dart';
import 'package:mobile_assessment/modules/widgets/inputs/app_textfield.dart';
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
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: EmSizes.lg),
            child: Column(
              children: [
                CustomTextField(
                  key: const Key('Employee_search'),
                  hintText: 'eg: name, designation, level',
                  controller: _searchController,
                  suffix: _searchController.text.isEmpty ?
                    const Icon(Icons.search, color: AppColors.greyColor,)
                      : InkWell(
                        onTap: () {
                          _searchController.text = '';
                          emProvider.resetFilter();
                        },
                        child: const Icon(Icons.clear, color: AppColors.blackColor,),
                  ),
                  onChanged: (value) {
                    value?.isNotEmpty == true ?
                      emProvider.filterEmployees(value!) : emProvider.resetFilter();

                  },
                ),

                employeesCard(emProvider),
              ],
            ),
          );
      }),
    );
  }

  Widget employeesCard(EmployeeProvider emProvider) {
    return Expanded(
      child: ListView.builder(
        itemCount: emProvider.employees.length,
        itemBuilder: (context, index) {
          final employee = emProvider.employees[index];
          return EmployeeCard(
          child: ListTile(
            title: Text('${employee.firstName} ${employee.lastName}'),
            subtitle: Text('${employee.designation} - Level: ${employee.level}'),
            trailing: Text('${employee.productivityScore}%'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsScreen(employee: employee),
                ),
              );
            },
          )
        );
      }),
    );
  }
}
