import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserblocEvent, UserblocState> {
  UserBloc() : super(UserblocInitial()) {
    on<UserblocEvent>((event, emit) {
      // TODO: implement event handler
    });

  }
}
