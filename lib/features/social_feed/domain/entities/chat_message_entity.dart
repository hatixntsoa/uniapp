/// Ticket: Gp6-5 — simple messaging/bot screen
class ChatMessageEntity {
  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isFromMe,
    required this.sentAt,
  });

  final String id;
  final String text;
  final bool isFromMe;
  final DateTime sentAt;
}
