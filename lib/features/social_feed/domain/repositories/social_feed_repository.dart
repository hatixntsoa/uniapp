import '../entities/activity_group_entity.dart';
import '../entities/post_entity.dart';

/// Ticket: Gp6-3/6-4 — repository contract
abstract class SocialFeedRepository {
  Future<List<PostEntity>> getPosts();
  Future<PostEntity> createPost(String content, {bool isOfficial = false});
  Future<void> toggleReaction(String postId);
  Future<void> addComment(String postId, String text);

  /// Gp6-3: basic moderation — hide a post.
  Future<void> hidePost(String postId);

  Future<List<ActivityGroupEntity>> getGroups();
  Future<void> toggleJoinGroup(String groupId);
}
