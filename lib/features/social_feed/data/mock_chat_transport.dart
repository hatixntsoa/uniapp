import 'dart:async';

import 'package:uuid/uuid.dart';

import '../domain/entities/chat_message_entity.dart';
import '../domain/services/chat_transport.dart';

/// Ticket: Gp6-5 — mock transport: echoes a canned bot reply after a delay.
/// Status: stubbed. Real transport (websocket/Firebase) plugs in behind
/// ChatTransport without touching the chat screen.
class MockChatTransport implements ChatTransport {
  final _controller = StreamController<ChatMessageEntity>.broadcast();

  @override
  Stream<ChatMessageEntity> get incomingMessages => _controller.stream;

  @override
  Future<void> sendMessage(String text) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _controller.add(
      ChatMessageEntity(
        id: const Uuid().v4(),
        text: _mockReply(text),
        isFromMe: false,
        sentAt: DateTime.now(),
      ),
    );
  }

  String _mockReply(String userText) {
    // TODO(Gp6-5): replace with a real bot/agent call once a backend
    // transport is chosen. This is a fixed canned response for demo purposes.
    return 'Merci pour votre message. Un assistant vous répondra bientôt.';
  }

  @override
  void dispose() {
    _controller.close();
  }
}
