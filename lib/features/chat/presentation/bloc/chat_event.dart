import 'package:meetly/features/chat/domain/entity/message_entity.dart';

abstract class ChatEvent{}

class JoinChatEvent extends ChatEvent{
  final String meetingId;

  JoinChatEvent({required this.meetingId});
}

class SendMessageEvent extends ChatEvent{
  final String meetingId;
  final String text;
  final MessageEntity? optimisticMessage;

  SendMessageEvent({required this.meetingId, required this.text, this.optimisticMessage});
}

class GetMessagesEvent extends ChatEvent{
  final bool refresh;
  final String meetId;

  GetMessagesEvent({this.refresh = false, required this.meetId});
}