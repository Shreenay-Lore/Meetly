import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meetly/features/create_meet/presentation/widgets/form_section.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_state.dart';

class MeetDetailsSection extends StatelessWidget {
  const MeetDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetBloc, MeetState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormSection(
              icon: Icons.event_note,
              label: 'Meet Details',
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
                      Theme.of(context).colorScheme.primary.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.meetEntity?.title}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            DateFormat('HH:mm · MMM dd').format(state.meetEntity?.date.toLocal() ?? DateTime.now()),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${state.meetEntity?.description}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              )
            ),
            
          ],
        );
      },
    );
  }
}