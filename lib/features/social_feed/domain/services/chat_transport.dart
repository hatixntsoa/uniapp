import '../entities/chat_message_entity.dart';

/// Ticket: Gp6-5 — pluggable transport interface.
/// Status: stubbed with an in-memory echo transport. Swap `MockChatTransport`
/// for a WebSocketChatTransport or FirebaseChatTransport implementing this
/// same interface once a real backend/bot is chosen; the UI never changes.
abstract class ChatTransport {
  Stream<ChatMessageEntity> get incomingMessages;
  Future<void> sendMessage(String text);
  void dispose();
}
