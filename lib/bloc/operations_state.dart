part of 'operations_bloc.dart';

@immutable
abstract class OperationsState {}

final class OperationsInitial extends OperationsState {}

class EmployeeLoading extends OperationsState{

}

class EmployeeLoaded extends OperationsState{
  final List<Employee> employee;
  EmployeeLoaded({required this.employee});
}

class EmployeeError extends OperationsState{
  final String error;
  EmployeeError({required this.error});
}


