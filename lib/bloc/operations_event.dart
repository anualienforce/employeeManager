part of 'operations_bloc.dart';

@immutable
sealed class OperationsEvent {}

class AddEmployee extends OperationsEvent{
  final Employee employee;
  AddEmployee({required this.employee});
}

class DeleteEmployee extends OperationsEvent{
  final String id;
  DeleteEmployee({required this.id});
}

class UpdateEmployee extends OperationsEvent{
  final String id;
  final Map<String, dynamic> updateField;

  UpdateEmployee({required this.id, required this.updateField});
}

class LoadEmployee extends OperationsEvent{

}
