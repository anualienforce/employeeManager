import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Employee {
  final String name;
  final Timestamp dateOfJoin;
  final double salary;
  Timestamp? dateOfResign;
  final bool isWorking;
  final String id;

  Employee({
    required this.id,
    required this.name,
    required this.dateOfJoin,
    required this.salary,
    this.dateOfResign,
    required this.isWorking,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfJoin': dateOfJoin,
      'salary': salary,
      'dateOfResign': isWorking ? null : dateOfResign,
      'isWorking': isWorking,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      dateOfJoin: map['dateOfJoin'],
      salary: map['salary'].toDouble(),
      dateOfResign: !map['isWorking']? map['dateOfResign']??Timestamp(0, 0):null,
      isWorking: map['isWorking'],
    );
  }
}
