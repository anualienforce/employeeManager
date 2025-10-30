import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeemanager/model/employees.dart';

class FirebaseRepository{
  final _employeeCollection = FirebaseFirestore.instance.collection('employees');

  Future<void> addEmployee (Employee employee)async{
    await _employeeCollection.doc(employee.id).set(employee.toMap());
  }

  Stream<List<Employee>> getEmployee(){
    return _employeeCollection.snapshots().map((snapShot)=>snapShot.docs.map((doc){
      return Employee.fromMap(doc.data());
    }).toList());
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> field)async{
    await _employeeCollection.doc(id).update(field);
  }
  Future<void> deleteEmployee(String id)async{
    await _employeeCollection.doc(id).delete();
  }
}