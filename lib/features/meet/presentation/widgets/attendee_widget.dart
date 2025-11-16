import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetly/features/auth/domain/entity/user_entity.dart';
import 'package:meetly/features/auth/presentation/bloc/user_bloc.dart';
import 'package:meetly/features/auth/presentation/bloc/user_state.dart';
import 'package:meetly/features/meet/domain/entity/meet_entity.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_event.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_state.dart';
import 'package:meetly/features/profile/presentation/widgets/circle_user_avatar.dart';

class AttendeeWidget extends StatelessWidget {
  final UserEntity attendee;

  const AttendeeWidget({super.key, required this.attendee});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        return BlocBuilder<MeetBloc, MeetState>(
          builder: (context, state) {
            final isAdmin = state.meetEntity?.admin.id == attendee.id;
            final isCurrentUserAdmin = state.meetEntity?.admin.id == userState.userEntity?.id;
            
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      Hero(
                        tag: 'avatar_${attendee.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleUserAvatar(
                            width: 48,
                            height: 48,
                            url: attendee.avatar,
                          ),
                        ),
                      ),
                      if (isAdmin)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.star_fill,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 16),
                  
                  // Name and role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                attendee.name,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isAdmin) ...[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Admin',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          isAdmin ? 'Organizer' : 'Attendee',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Action button
                  _buildActionButton(context, state.meetEntity, attendee, userState.userEntity, isAdmin, isCurrentUserAdmin),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, 
    MeetEntity? meetEntity, 
    UserEntity attendee, 
    UserEntity? user,
    bool isAdmin,
    bool isCurrentUserAdmin,
  ) {
    if (isAdmin && !isCurrentUserAdmin) {
      // Show admin star for non-admin users viewing the admin
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          CupertinoIcons.star_fill,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      );
    }
    
    if (isCurrentUserAdmin && !isAdmin) {
      // Show menu for admin managing other users
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAdminMenu(context, attendee),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.more_horiz,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      );
    }
    
    return SizedBox(width: 8);
  }
  
  void _showAdminMenu(BuildContext context, UserEntity attendee) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header with avatar
              Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Row(
                  children: [
                    CircleUserAvatar(
                      width: 56,
                      height: 56,
                      url: attendee.avatar,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attendee.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage attendee',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Divider(height: 1),
              
              // Menu options
              _buildMenuOption(
                context: context,
                icon: CupertinoIcons.person_circle,
                title: 'View Profile',
                subtitle: 'See full profile picture',
                iconColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showProfileDialog(context, attendee);
                },
              ),
              
              _buildMenuOption(
                context: context,
                icon: CupertinoIcons.star_circle_fill,
                title: 'Make Admin',
                subtitle: 'Transfer admin rights',
                iconColor: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  context.read<MeetBloc>().add(TransferAdminEvent(userId: attendee.id));
                  Navigator.pop(bottomSheetContext);
                  _showSnackBar(context, '${attendee.name} is now the admin', Icons.star);
                },
              ),
              
              _buildMenuOption(
                context: context,
                icon: CupertinoIcons.xmark_circle_fill,
                title: 'Remove from Meet',
                subtitle: 'Kick this attendee',
                iconColor: Theme.of(context).colorScheme.error,
                isDestructive: true,
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showKickConfirmation(context, attendee);
                },
              ),
              
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMenuOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive 
                          ? Theme.of(context).colorScheme.error 
                          : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showProfileDialog(BuildContext context, UserEntity attendee) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              attendee.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(dialogContext),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                      child: CachedNetworkImage(
                        imageUrl: attendee.avatar,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 300,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 300,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.person, size: 80),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showKickConfirmation(BuildContext context, UserEntity attendee) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  color: Theme.of(context).colorScheme.error,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Remove Attendee?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove ${attendee.name} from this meet? This action cannot be undone.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<MeetBloc>().add(KickUserEvent(userId: attendee.id));
                Navigator.pop(dialogContext);
                _showSnackBar(context, '${attendee.name} removed', Icons.check_circle);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Remove',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _showSnackBar(BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text(
              message,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        margin: EdgeInsets.all(16),
      ),
    );
  }
}