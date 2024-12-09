import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/post_repository.dart';
import '../utils/local_storage.dart';
import '../utils/widget_constants.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  final LocalStorage localStorage;

  PostBloc({required this.postRepository, required this.localStorage})
      : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final localPosts = await localStorage.getPosts();

      emit(PostLoaded(posts: localPosts));

      final apiPosts = await postRepository.fetchPosts();
      await localStorage.savePosts(apiPosts);

      emit(PostLoaded(posts: apiPosts));
    } catch (e) {
      errorToast(
          content:
              "Something went wrong, Please try again after checking your internet connection!");
    }
  }
}
