import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hamora/models/models.dart';
import 'package:hamora/services/services.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      try {
        User user = await UserServices.getUser(event.id);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserInitial());
      }
    });

    on<SignOut>((event, emit) {
      emit(UserInitial());
    });

    on<UpdateData>(
      (event, emit) async {
        try {
          if (state is UserLoaded) {
            User user = (state as UserLoaded).user.copyWith(
                  name: event.name,
                );
            await UserServices.updateUser(user);
            emit(UserLoaded(user));
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
