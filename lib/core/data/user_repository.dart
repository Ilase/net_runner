
import 'package:equatable/equatable.dart';

class UserRepository extends Equatable {
  Map<String, dynamic> userData;
  Map<String, dynamic> userPermissions;

  UserRepository(this.userData, this.userPermissions);

  @override
  List<Object?> get props => [userData, userPermissions];
}