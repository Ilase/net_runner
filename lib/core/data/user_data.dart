

import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

//add more fields
class User extends Equatable{
  String userName;
  String passkeyHash;
  Map<String, dynamic> permissions = {};
  var cache;

  User({required this.userName, required this.passkeyHash});


  @override
  List<Object?> get props => [userName, cache];
}