import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knovator_flutter_test/blocs/post_event.dart';
import 'package:knovator_flutter_test/screens/onboarding_screen.dart';
import 'package:knovator_flutter_test/screens/splash_screen.dart';
import 'blocs/post_bloc.dart';
import 'repositories/post_repository.dart';
import 'utils/local_storage.dart';
import 'screens/post_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final postRepository = PostRepository();
    final localStorage = LocalStorage();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PostBloc(
            postRepository: postRepository,
            localStorage: localStorage,
          )..add(LoadPosts()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const PostListScreen(),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/home': (context) => const PostListScreen(),
        },
      ),
    );
  }
}
