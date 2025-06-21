import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_assessment/common/colors.dart';
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
  late TextEditingController _salaryController;
  late int _level;
  bool _isEditing = false;
  late String newSalary;
  late String status;
  late Employee _employee;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
    setValues();
  }

  setValues() {
    _scoreController = TextEditingController(text: _employee.productivityScore.toString());
    _level = _employee.level;
    newSalary = EmploymentUtils.getNewSalary(_level, _employee.productivityScore);
    status =  EmploymentUtils.getStatus(_employee.productivityScore, _level);
    _salaryController = TextEditingController(text: _employee.currentSalary.replaceAll(',', ''));
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = _employee;

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
                setValues();
              });
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: EmSizes.lg),
        child: Form(
          key: _formKey,
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
                  return null;
                },
                (value) {
                  setState(() {
                    value?.isNotEmpty == true ? status = EmploymentUtils.getStatus(double.parse(_scoreController.text), _level) : status = status;
                    print(status);
                  });
                }
              )
                  :
              _buildReadOnly("Productivity Score", emp.productivityScore.toString()),

              _isEditing
                  ? _buildEditable(
                "Salary",
                _salaryController,
                TextInputType.number,
                    (value) {
                  final salary = double.tryParse(value ?? '');
                  if (salary == null || salary < 70000 || salary > 250000) {
                    return 'Salary must be between 70,000 and 250,000';
                  }
                  return null;
                },
                  (value){}
              )
                  :
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
                    if(_formKey.currentState?.validate() ?? false) {
                      final emProvider = Provider.of<EmployeeProvider>(context, listen: false);
                      final updated = _employee.copyWith(
                          productivityScore: double.parse(_scoreController.text),
                          level: _level,
                          currentSalary: EmploymentUtils.formatCurrency(int.parse(_salaryController.text))
                      );

                      try {
                        await emProvider.saveChanges(updated);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Changes saved!")),
                          );
                          setState(() {
                            _isEditing = false;

                            _employee = updated;

                            _scoreController.text = updated.productivityScore.toString();
                            _salaryController.text = updated.currentSalary.replaceAll(',', '');
                            _level = _employee.level;
                          });
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in the correct values"), backgroundColor: AppColors.errorColor,),
                      );
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEditable(String label, TextEditingController controller, TextInputType inputType, String? Function(String?)? validator, Function(String?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CustomTextField(
        key: Key(label),
        controller: controller,
        hintText: 'Enter $label',
        labelText: label,
        keyboardType: inputType,
        validator: validator,
        onChanged: onChanged,
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
                newSalary = EmploymentUtils.getNewSalary(_level, _employee.productivityScore);
              });
            },
          )
        ],
      ),
    );
  }
}
