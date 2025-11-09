import 'package:go_router/go_router.dart';
import 'package:meetly/features/auth/presentation/page/auth_page.dart';
import 'package:meetly/features/chat/presentation/page/chat_page.dart';
import 'package:meetly/features/create_meet/presentation/page/create_meet_page.dart';
import 'package:meetly/features/create_meet/presentation/page/location_picker_page.dart';
import 'package:meetly/features/main/presentation/page/main_page.dart';
import 'package:meetly/features/meet/presentation/page/meet_page.dart';
import 'package:meetly/features/profile/presentation/page/edit_profile_page.dart';
import 'package:meetly/features/profile/presentation/page/profile_page.dart';
import 'package:meetly/splash_page.dart';

class AppRouter{
  static var router = GoRouter(
    initialLocation: SplashPage.route,
    routes: [
      GoRoute(path: SplashPage.route,builder: (context,state){
        return const SplashPage();
      }),
      GoRoute(path: AuthPage.route,builder: (context,state){
        return const AuthPage();
      }),
      GoRoute(path: MainPage.route,builder: (context,state){
        return const MainPage();
      }),
      GoRoute(path: ProfilePage.route,builder: (context,state){
        return const ProfilePage();
      }),
      GoRoute(path: EditProfilePage.route,builder: (context,state){
        return const EditProfilePage();
      }),
      GoRoute(path: CreateMeetPage.route,builder: (context,state){
        return const CreateMeetPage();
      }),
      GoRoute(path: LocationPickerPage.route,builder: (context,state){
        return const LocationPickerPage();
      }),
      GoRoute(path: '/meet/:id',builder: (context,state){
        return MeetPage(meetId: state.pathParameters['id'] ?? '');
      }),
      GoRoute(path: '/chat/:id',builder: (context,state){
        return ChatPage(meetId: state.pathParameters['id'] ?? '',);
      })
    ],
  );
}