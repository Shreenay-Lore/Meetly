import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meetly/core/ui/default_button.dart';
import 'package:meetly/features/auth/presentation/bloc/user_bloc.dart';
import 'package:meetly/features/auth/presentation/bloc/user_state.dart';
import 'package:meetly/features/chat/presentation/page/chat_page.dart';
import 'package:meetly/features/main/presentation/page/main_page.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_event.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_state.dart';

class MeetBottomButtons extends StatelessWidget {
  const MeetBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetBloc, MeetState>(
      builder: (context, meetState) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (!(meetState.meetEntity?.attendees
                    .any((e) => e.id == state.userEntity?.id) ??
                false)) {
              return DefaultButton(
                onPressed: () {
                  context.read<MeetBloc>().add(JoinMeetEvent());
                },
                icon: Icons.group_add,
                text:'Join Meet',
              );
            }
            
            if(meetState.meetEntity?.admin.id == state.userEntity?.id){
              return Row(
                children: [
                  Expanded(
                    child: DefaultButton(
                      onPressed: () {
                        context.go(MainPage.route);
                      },
                      text: "Back to Home",
                    ),
                  ),
                  if(!(meetState.meetEntity?.isFinished ?? true)) ...[
                    SizedBox(width: 12),
                    Expanded(
                      child: DefaultButton(
                        onPressed: () {
                          context.read<MeetBloc>().add(CancelMeetEvent());
                        },
                        text: "Cancel Meet",
                        backgroundColor: Theme.of(context).colorScheme.error,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              );
            }
            
            return Row(
              children: [
                Expanded(
                  child: DefaultButton(
                    text: 'Chat',
                    onPressed: (){
                      context.push(ChatPage.route(meetState.meetEntity?.id ?? ''));
                    },
                  )
                ),
                if(!(meetState.meetEntity?.isFinished ?? true)) ...[
                  SizedBox(width: 12),
                  Expanded(
                    child: DefaultButton(
                      onPressed: () {
                        context.read<MeetBloc>().add(LeaveMeetEvent());
                      },
                      text: "Leave Meet",
                      backgroundColor: Theme.of(context).colorScheme.error,
                      textColor: Colors.white,
                    ),
                  ),
                
                ],
              ],
            );
          },
        );
      },
    );
  }
}