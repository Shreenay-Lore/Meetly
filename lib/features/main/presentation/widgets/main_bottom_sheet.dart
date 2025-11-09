import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetly/features/main/presentation/bloc/main_bloc.dart';
import 'package:meetly/features/main/presentation/bloc/main_event.dart';
import 'package:meetly/features/main/presentation/bloc/main_state.dart';
import 'package:meetly/features/main/presentation/widgets/current_meet_widget.dart';
import 'package:meetly/features/main/presentation/widgets/nearby_meet_widget.dart';

class MainBottomSheet extends StatelessWidget {
  const MainBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .28,
      minChildSize: .25,
      maxChildSize: .75,
      builder: (context, scrollController) {
        return BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, -5),
                    color: Colors.black.withOpacity(.15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<MainBloc>().add(GetNearbyMeetsEvent());
                      context.read<MainBloc>().add(GetCurrentMeetsEvent());
                    },
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle with enhanced design
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              height: 5,
                              width: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey[300]!,
                                    Colors.grey[400]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          
                          // Current Meets Section
                          if (state.currentMeets?.isNotEmpty ?? false) ...[
                            _buildSectionHeader(
                              context,
                              title: "Current Meets",
                              icon: Icons.event_available_rounded,
                              count: state.currentMeets?.length ?? 0,
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(
                              state.currentMeets?.length ?? 0,
                              (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildCardWrapper(
                                  child: CurrentMeetWidget(
                                    meetEntity: state.currentMeets![i],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Nearby Meets Section
                          _buildSectionHeader(
                            context,
                            title: "Nearby Meets",
                            icon: Icons.near_me_rounded,
                            count: state.nearbyMeets?.length ?? 0,
                          ),
                          const SizedBox(height: 16),
                          
                          if (state.nearbyMeets?.isEmpty ?? true)
                            _buildEmptyState(context)
                          else
                            ...List.generate(
                              state.nearbyMeets?.length ?? 0,
                              (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildCardWrapper(
                                  child: NearbyMeetWidget(
                                    meetEntity: state.nearbyMeets![i],
                                  ),
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.explore_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No meets nearby',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pull to refresh or zoom out to see more..',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[400],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}