
import 'package:equatable/equatable.dart';
import 'package:net_runner/core/data/user_data.dart';

class UserRepository extends Equatable {
  List<User>? userData;
  var cache;
  //Map<String, dynamic> userPermissions;

  UserRepository();

  @override
  List<Object?> get props => [userData, cache];
}