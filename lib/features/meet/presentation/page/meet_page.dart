import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meetly/core/get_it/get_it.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_event.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_state.dart';
import 'package:meetly/features/meet/presentation/widgets/meet_attendees_section.dart';
import 'package:meetly/features/meet/presentation/widgets/meet_bottom_buttons.dart';
import 'package:meetly/features/meet/presentation/widgets/meet_details_section.dart';
import 'package:meetly/features/meet/presentation/widgets/meet_location_section.dart';

class MeetPage extends StatelessWidget {
  final String meetId;

  const MeetPage({super.key, required this.meetId});

  static String route(String meetId) => '/meet/$meetId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MeetBloc>()..add(GetMeetEvent(meetId: meetId)),
      child: BlocConsumer<MeetBloc, MeetState>(
        listener: (context, state) {
          if(state.status == MeetStatus.left || state.status == MeetStatus.canceled){
            context.pop();
          }
        },
        builder: (context, state) {
          if(state.status == MeetStatus.loading){
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    SizedBox(height: 16),
                    Text(
                      'Loading meet details...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Meet from ${state.meetEntity?.admin.name}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              centerTitle: false,
            ),
            body: const Padding(
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        MeetDetailsSection(),
                        SizedBox(height: 15,),
                        MeetAttendeesSection(),
                        SizedBox(height: 15,),
                        MeetLocationSection(),
                        SizedBox(height: 55,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: MeetBottomButtons(),
            ),
          );
        },
      ),
    );
  }
}
