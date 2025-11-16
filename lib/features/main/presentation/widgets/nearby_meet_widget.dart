import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meetly/core/ui/default_button.dart';
import 'package:meetly/features/auth/presentation/bloc/user_bloc.dart';
import 'package:meetly/features/auth/presentation/bloc/user_state.dart';
import 'package:meetly/features/meet/domain/entity/meet_entity.dart';
import 'package:meetly/features/meet/presentation/page/meet_page.dart';
import 'package:meetly/features/profile/presentation/widgets/circle_user_avatar.dart';

class NearbyMeetWidget extends StatelessWidget {
  final MeetEntity meetEntity;

  const NearbyMeetWidget({super.key, required this.meetEntity});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final isUserAttending = meetEntity.attendees.any((u) => u.id == state.userEntity?.id);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(MeetPage.route(meetEntity.id)),
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meetEntity.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),     
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 14,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${meetEntity.date.hour.toString().padLeft(2, '0')}:${meetEntity.date.minute.toString().padLeft(2, '0')}',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: Stack(
                              children: [
                                ...List.generate(
                                  meetEntity.attendees.length > 4 ? 4 : meetEntity.attendees.length,
                                  (index) {
                                    return Positioned(
                                      left: index * 28.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.surface,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CircleUserAvatar(
                                          width: 40,
                                          height: 40,
                                          url: meetEntity.attendees[index].avatar,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if (meetEntity.attendees.length > 4)
                                  Positioned(
                                    left: 4 * 28.0,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.surface,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${meetEntity.attendees.length - 4}',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      
                        if (!isUserAttending)
                          DefaultButton(
                            height: 42,
                            width: 90,
                            onPressed: () => context.push(MeetPage.route(meetEntity.id)),
                            icon: Icons.add_rounded,
                            iconSize: 20,
                            text: 'Join',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                            ),
                            radius: 14,
                          )
                        else
                        DefaultButton(
                            height: 42,
                            width: 100,
                            onPressed: () {},
                            icon: Icons.check_circle_rounded,
                            iconSize: 18,
                            text: 'Joined',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                            ),
                            radius: 14,
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}