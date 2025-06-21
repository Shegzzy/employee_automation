import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_assessment/common/sizes.dart';
import 'package:mobile_assessment/models/employee_model.dart';
import 'package:mobile_assessment/modules/widgets/inputs/app_textfield.dart';
import 'package:mobile_assessment/service/providers/employees_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/employment_utils.dart';

class DetailsScreen extends StatefulWidget {
  final Employee employee;
  const DetailsScreen({Key? key, required this.employee}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController _scoreController;
  late int _level;
  bool _isEditing = false;
  late String newSalary;


  @override
  void initState() {
    super.initState();
    _scoreController = TextEditingController(text: widget.employee.productivityScore.toString());
    _level = widget.employee.level;
    newSalary = EmploymentUtils.getNewSalary(_level, widget.employee.productivityScore);
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.employee;
    final status = EmploymentUtils.getStatus(emp.productivityScore, emp.level);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: EmSizes.lg),
        child: ListView(
          children: [
            _buildReadOnly("Full Name", "${emp.firstName} ${emp.lastName}"),
            _buildReadOnly("Designation", emp.designation),

            _isEditing
                ? _buildLevelPicker()
                : _buildReadOnly("Level", "$_level"),

            _isEditing
                ? _buildEditable(
              "Productivity Score",
              _scoreController,
              TextInputType.number,
              (value) {
                final score = double.tryParse(value ?? '');
                if (score == null || score < 0 || score > 100) {
                  return 'Score must be between 0 and 100';
                }
                return '';
              },
            )
                :
            _buildReadOnly("Productivity Score", emp.productivityScore.toString()),

            _buildReadOnly("Current Salary", "₦${emp.currentSalary}"),
            const Divider(height: 32),
            _buildReadOnly("New Status", status),
            _buildReadOnly("New Salary", newSalary),
            const SizedBox(height: 24),

            if (_isEditing)
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                onPressed: () async {
                  final emProvider = Provider.of<EmployeeProvider>(context, listen: false);
                  final updated = widget.employee.copyWith(
                    productivityScore: double.parse(_scoreController.text),
                    level: _level,
                  );

                  try {
                    await emProvider.saveChanges(updated);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Changes saved!")),
                      );
                      setState(() {
                        _isEditing = false;
                      });
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEditable(String label, TextEditingController controller, TextInputType inputType, String Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CustomTextField(
        controller: controller,
        hintText: 'productivity score 0-100',
        labelText: label,
        keyboardType: inputType,
        validator: validator,
      ),
    );
  }

  Widget _buildLevelPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Text("Level: ", style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(width: 4,),

          DropdownButton<int>(
            value: _level,
            items: List.generate(6, (index) => index).map((lvl) {
              return DropdownMenuItem<int>(
                value: lvl,
                child: Text("$lvl"),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _level = val!;
                newSalary = EmploymentUtils.getNewSalary(_level, widget.employee.productivityScore);
              });
            },
          )
        ],
      ),
    );
  }
}
