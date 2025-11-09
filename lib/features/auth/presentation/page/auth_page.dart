import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meetly/features/auth/presentation/bloc/user_bloc.dart';
import 'package:meetly/features/auth/presentation/bloc/user_event.dart';
import 'package:meetly/features/auth/presentation/bloc/user_state.dart';
import 'package:meetly/features/main/presentation/page/main_page.dart';

class AuthPage extends StatelessWidget {
  static const String route = '/auth';

  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == UserStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.errorMessage}'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        if (state.status == UserStatus.success) {
          context.go(MainPage.route);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Color(0xFF1a1a2e),
                      Color(0xFF16213e),
                      Color(0xFF0f3460),
                    ]
                  : [
                      Color(0xFFf8f9fa),
                      Color(0xFFe9ecef),
                      Color(0xFFdee2e6),
                    ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Logo and Brand Section
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Meetly',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                    
                        // Animated Container for Logo
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                blurRadius: 60,
                                spreadRadius: 0.2,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/auth_bg.png',
                            height: size.height * 0.35
                          ),
                        ),
                        
                        
                      ],
                    ),
                  ),

                  // Content Section
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main Headline
                        Text(
                          'Find events.\nMeet people.\nStay connected!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Subheadline
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Discover exciting events nearby, connect with new people, and create your own meetups!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  height: 1.5,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Sign In Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 0.5),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<UserBloc>().add(SignInWithGoogleEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              foregroundColor: Theme.of(context).colorScheme.onSurface,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black12,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/images/google.svg',
                              height: 24,
                              width: 24,
                            ),
                            label: Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Privacy Note
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'By continuing, you agree to our Terms of Service and Privacy Policy',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}