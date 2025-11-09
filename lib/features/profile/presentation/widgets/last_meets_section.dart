import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetly/features/profile/presentation/bloc/last_meets_bloc.dart';
import 'package:meetly/features/profile/presentation/bloc/last_meets_state.dart';
import 'package:meetly/features/profile/presentation/widgets/last_meet_widget.dart';

class LastMeetsSection extends StatelessWidget {
  const LastMeetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LastMeetsBloc, LastMeetsState>(
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return LastMeetWidget(meetEntity: state.lastMeets![index]);
          },
          separatorBuilder:(context,index){
            return const SizedBox(height: 10,);
          },
          itemCount: state.lastMeets?.length ?? 0,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      },
    );
  }
}
