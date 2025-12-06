import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetly/features/profile/presentation/bloc/last_meets_bloc.dart';
import 'package:meetly/features/profile/presentation/bloc/last_meets_event.dart';
import 'package:meetly/features/profile/presentation/bloc/last_meets_state.dart';
import 'package:meetly/features/profile/presentation/widgets/last_meet_widget.dart';

class LastMeetsSection extends StatelessWidget {
  const LastMeetsSection({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<LastMeetsBloc>().add(GetLastMeetsEvent(refresh: true));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LastMeetsBloc, LastMeetsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: state.lastMeets?.isEmpty ?? true
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(
                        child: Text('No meets found'),
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return LastMeetWidget(meetEntity: state.lastMeets![index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemCount: state.lastMeets?.length ?? 0,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 8),
                ),
        );
      },
    );
  }
}
