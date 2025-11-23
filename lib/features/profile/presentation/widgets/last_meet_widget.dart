import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meetly/features/meet/domain/entity/meet_entity.dart';
import 'package:meetly/features/meet/presentation/page/meet_page.dart';
import 'package:meetly/features/profile/presentation/widgets/circle_user_avatar.dart';

class LastMeetWidget extends StatelessWidget {

  final MeetEntity meetEntity;

  const LastMeetWidget({super.key, required this.meetEntity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(MeetPage.route(meetEntity.id));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meetEntity.title,style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),),
                  const SizedBox(height: 4,),
                  Text('${meetEntity.date.hour.toString().padLeft(2, '0')}:${meetEntity.date.minute.toString().padLeft(2, '0')} • ${DateFormat.yMMMd().format(meetEntity.date)}',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),),
                ],
              ),
            ),
            const SizedBox(width: 12,),
            SizedBox(
              width: meetEntity.attendees.length * 16 + 14,
              height: 30,
              child: Stack(
                children: List.generate(
                  meetEntity.attendees.length,
                  (index) => Positioned(
                    left: index * 16.0,
                    child: CircleUserAvatar(
                      width: 30,
                      height: 30,
                      url: meetEntity.attendees[index].avatar,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
