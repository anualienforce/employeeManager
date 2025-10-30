import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeemanager/bloc/operations_bloc.dart';
import 'package:employeemanager/model/employees.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeAction extends StatelessWidget {
  const EmployeeAction({super.key});



  @override
  Widget build(BuildContext context) {
    context.read<OperationsBloc>().add(LoadEmployee());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Manager'),
        centerTitle: true,
      ),
      body: BlocConsumer<OperationsBloc, OperationsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeLoaded) {
            final employees = state.employee;
            if (employees.isEmpty) {
              return const Center(child: Text('No Employees Found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final emp = employees[index];

                //Check if employee has worked 5+ years
                final yearsWorked = DateTime.now()
                    .difference(emp.dateOfJoin.toDate())
                    .inDays /
                    365;
                final isVeteran = emp.isWorking && yearsWorked >= 5;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isVeteran ? Colors.green : Colors.blue,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(emp.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    subtitle: Text(
                      'Salary: ₹${emp.salary.toStringAsFixed(2)}\nJoined: ${DateFormat('dd MMM yyyy').format(emp.dateOfJoin.toDate())}'
                          '${emp.isWorking ? '' : '\nResigned: ${DateFormat('dd MMM yyyy').format(emp.dateOfResign!.toDate())}'}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        _showEmployeeDialog(context, employee: emp);
                      },
                    ),
                  ),
                );
              },
            );
          }

          if (state is EmployeeError) {
            return Center(child: Text(state.error));
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmployeeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Function to show add or update employee dialog
  void _showEmployeeDialog(BuildContext context, {Employee? employee}) async {
    final nameController = TextEditingController(text: employee?.name ?? '');
    final salaryController =
    TextEditingController(text: employee?.salary.toString() ?? '');
    DateTime? dateOfJoin =
        employee?.dateOfJoin.toDate() ?? DateTime.now();
    DateTime? dateOfResign =
    employee?.dateOfResign?.toDate();
    bool isWorking = employee?.isWorking ?? true;

    bool isUpdated = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(employee == null
                ? 'Add Employee'
                : 'Update Employee'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: salaryController,
                    decoration: const InputDecoration(
                      labelText: 'Salary',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                        'Date of Joining: ${DateFormat('dd MMM yyyy').format(dateOfJoin!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dateOfJoin,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => dateOfJoin = picked);
                      }
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Currently Working'),
                    value: isWorking,
                    onChanged: (val) {
                      setState(() {
                        isWorking = val;
                        if (val) dateOfResign = null;
                      });
                    },
                  ),
                  if (!isWorking)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        dateOfResign == null
                            ? 'Select Resignation Date'
                            : 'Date of Resign: ${DateFormat('dd MMM yyyy').format(dateOfResign!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dateOfJoin?.add(const Duration(days: 1)),
                          firstDate: dateOfJoin!.add(const Duration(days: 1)),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          if (picked.isAtSameMomentAs(dateOfJoin!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Resign date cannot be same as joining date')),
                            );
                          } else if (picked.isBefore(dateOfJoin!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Resign date cannot be before joining date')),
                            );
                          } else {
                            setState(() => dateOfResign = picked);
                          }
                        }
                      },
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final salary = double.tryParse(salaryController.text) ?? 0;

                  if (name.isEmpty || salary <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid name and salary')),
                    );
                    return;
                  }

                  if (!isWorking && dateOfResign == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please select a resignation date for non-working employee')),
                    );
                    return;
                  }

                  final repo = context.read<OperationsBloc>();
                  final id = employee?.id ??
                      FirebaseFirestore.instance
                          .collection('employees')
                          .doc()
                          .id;

                  final newEmp = Employee(
                    id: id,
                    name: name,
                    salary: salary,
                    dateOfJoin: Timestamp.fromDate(dateOfJoin!),
                    dateOfResign: isWorking
                        ? null
                        : Timestamp.fromDate(dateOfResign!),
                    isWorking: isWorking,
                  );

                  //Detect if any change in update
                  if (employee != null) {
                    final oldMap = employee.toMap();
                    final newMap = newEmp.toMap();

                    final hasChanges = !mapEquals(oldMap, newMap);
                    if (!hasChanges) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No changes detected.')),
                      );
                      return;
                    }
                    repo.add(UpdateEmployee(id: employee.id, updateField: newMap));
                  } else {
                    repo.add(AddEmployee(employee: newEmp));
                  }

                  Navigator.pop(context);
                },
                child: Text(employee == null ? 'Add' : 'Update'),
              ),
            ],
          );
        });
      },
    );
  }
}
