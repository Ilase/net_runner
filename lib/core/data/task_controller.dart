import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class TaskController extends Equatable {
  List<Map<String,dynamic>> dataList = [];
  String id;

  TaskController() : id = const Uuid().v4();
  TaskController.resave(List<Map<String,dynamic>> tasks) : id = const Uuid().v4(), dataList = tasks;
  
  void updateList(String handledData){
    Map<String,dynamic> newItem = jsonDecode(handledData);
    int index = dataList.indexWhere((item) => item['ID'] == newItem['ID']);
    if(index != -1){
      dataList[index] = newItem;
    } else {
      dataList.add(newItem);
    }
  }
  void resave(List<Map<String,dynamic>> tasks){
    dataList = tasks;
  }

  @override
  List<Object?> get props => [id];
}