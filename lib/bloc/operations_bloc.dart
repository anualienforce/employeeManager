import 'package:bloc/bloc.dart';
import 'package:employeemanager/model/employees.dart';
import 'package:employeemanager/repository/firebase_repository.dart';
import 'package:meta/meta.dart';

part 'operations_event.dart';

part 'operations_state.dart';

class OperationsBloc extends Bloc<OperationsEvent, OperationsState> {
  final FirebaseRepository _firebaseRepository;

  OperationsBloc(this._firebaseRepository) : super(OperationsInitial()) {
    on<AddEmployee>(_onAddEmployee);
    on<DeleteEmployee>(_onRemoveEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<LoadEmployee>(_onGetEmployees);
  }

  void _onGetEmployees(
    LoadEmployee event,
    Emitter<OperationsState> emit,
  ) async {
    emit(EmployeeLoading());
    await emit.forEach<List<Employee>>(
      _firebaseRepository.getEmployee(),
      onData: (employee) {
        return EmployeeLoaded(employee: employee);
      },
      onError: (error, _) {
        return EmployeeError(error: "Failed to load employees $error");
      },
    );
  }

  void _onUpdateEmployee(UpdateEmployee event, Emitter<OperationsState> emit) {
    _firebaseRepository.updateEmployee(event.id, event.updateField);
  }

  void _onRemoveEmployee(DeleteEmployee event, Emitter<OperationsState> emit) {
    _firebaseRepository.deleteEmployee(event.id);
  }

  void _onAddEmployee(AddEmployee event, Emitter<OperationsState> emit) {
    _firebaseRepository.addEmployee(event.employee);
  }
}
