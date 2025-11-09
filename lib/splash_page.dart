import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meetly/features/auth/presentation/bloc/user_bloc.dart';
import 'package:meetly/features/auth/presentation/bloc/user_state.dart';
import 'package:meetly/features/main/presentation/page/main_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String route = '/splash';
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if(state.status == UserStatus.success){
          // For test only
          context.go(MainPage.route);
        }
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 500,
              height: 500,
            ),
          ),
        ),
    );
  }
}
