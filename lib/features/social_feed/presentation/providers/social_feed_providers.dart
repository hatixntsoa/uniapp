import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_chat_transport.dart';
import '../../data/social_feed_repository_impl.dart';
import '../../domain/entities/activity_group_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/social_feed_repository.dart';
import '../../domain/services/chat_transport.dart';

/// Ticket: Gp6-3/6-4/6-5 — providers
final socialFeedRepositoryProvider = Provider<SocialFeedRepository>((ref) {
  return MockSocialFeedRepository();
});

final chatTransportProvider = Provider<ChatTransport>((ref) {
  final transport = MockChatTransport();
  ref.onDispose(transport.dispose);
  return transport;
});

final postListProvider =
    AsyncNotifierProvider<PostListNotifier, List<PostEntity>>(
      PostListNotifier.new,
    );

class PostListNotifier extends AsyncNotifier<List<PostEntity>> {
  @override
  Future<List<PostEntity>> build() {
    return ref.read(socialFeedRepositoryProvider).getPosts();
  }

  Future<void> createPost(String content, {bool isOfficial = false}) async {
    await ref
        .read(socialFeedRepositoryProvider)
        .createPost(content, isOfficial: isOfficial);
    ref.invalidateSelf();
  }

  Future<void> toggleReaction(String postId) async {
    await ref.read(socialFeedRepositoryProvider).toggleReaction(postId);
    ref.invalidateSelf();
  }

  Future<void> addComment(String postId, String text) async {
    await ref.read(socialFeedRepositoryProvider).addComment(postId, text);
    ref.invalidateSelf();
  }

  Future<void> hidePost(String postId) async {
    await ref.read(socialFeedRepositoryProvider).hidePost(postId);
    ref.invalidateSelf();
  }
}

final groupListProvider =
    AsyncNotifierProvider<GroupListNotifier, List<ActivityGroupEntity>>(
      GroupListNotifier.new,
    );

class GroupListNotifier extends AsyncNotifier<List<ActivityGroupEntity>> {
  @override
  Future<List<ActivityGroupEntity>> build() {
    return ref.read(socialFeedRepositoryProvider).getGroups();
  }

  Future<void> toggleJoin(String groupId) async {
    await ref.read(socialFeedRepositoryProvider).toggleJoinGroup(groupId);
    ref.invalidateSelf();
  }
}
