import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/search/domain/repository/search_repo.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepo searchRepo;
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUser(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
    } else {
      try {
        emit(SearchLoading());
        final users = await searchRepo.searchUsers(query);
        if (users.isEmpty) {
          emit(SearchError(message: 'There is no user match'));
        } else {
          emit(SearchLoaded(user: users));
        }
      } catch (exception) {
        emit(SearchError(message: 'Failed to search users: $exception'));
      }
    }
  }
}
