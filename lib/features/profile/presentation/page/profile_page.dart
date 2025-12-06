import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetly/core/get_it/get_it.dart';
import 'package:meetly/features/auth/presentation/bloc/user_bloc.dart';
import 'package:meetly/features/auth/presentation/bloc/user_state.dart';
import 'package:meetly/features/profile/presentation/bloc/last_meets_bloc.dart';
import 'package:meetly/features/profile/presentation/bloc/last_meets_event.dart';
import 'package:meetly/features/profile/presentation/widgets/circle_user_avatar.dart';
import 'package:meetly/features/profile/presentation/widgets/last_meets_section.dart';
import 'package:meetly/features/profile/presentation/widgets/profile_options_bottomsheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LastMeetsBloc>()..add(GetLastMeetsEvent(refresh: true)),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildProfileCard(context, state),
                    const SizedBox(height: 28),
                    Text(
                      'Last meets',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    const Expanded(child: LastMeetsSection()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Profile',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            ProfileOptionsBottomSheet.show(context);
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, UserState state) {
    final user = state.userEntity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          CircleUserAvatar(
            height: 90,
            width: 90,
            url: user?.avatar,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.7),
                      ),
                ),
                if ((user?.bio ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    user!.bio!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
