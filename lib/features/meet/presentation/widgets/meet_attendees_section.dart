import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_state.dart';
import 'package:meetly/features/meet/presentation/widgets/attendee_widget.dart';

class MeetAttendeesSection extends StatelessWidget {
  const MeetAttendeesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetBloc, MeetState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.people,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Attendees',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${state.meetEntity?.attendees.length ?? 0}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return AttendeeWidget(
                    attendee: state.meetEntity!.attendees[index]
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  height: 24,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
                itemCount: state.meetEntity?.attendees.length ?? 0,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
              ),
            )
          ],
        );
      },
    );
  }
}