import 'package:uuid/uuid.dart';

import '../domain/entities/activity_group_entity.dart';
import '../domain/entities/post_entity.dart';
import '../domain/repositories/social_feed_repository.dart';

/// Ticket: Gp6-3/6-4 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /feed/posts, /feed/groups
/// once backend is available. Interface stays identical.
class MockSocialFeedRepository implements SocialFeedRepository {
  final List<PostEntity> _posts = [
    PostEntity(
      id: 'post-1',
      authorName: 'Administration',
      authorRoleLabel: 'Officiel',
      content: 'Les inscriptions au semestre 2 débutent le 5 janvier. Merci de vérifier vos dossiers sur votre espace étudiant.',
      postedAt: DateTime.now().subtract(const Duration(hours: 3)),
      isOfficial: true,
      reactionCount: 24,
      comments: [
        CommentEntity(
          id: 'c-1',
          authorName: 'Lina Meziane',
          text: 'Merci pour l\'info !',
          postedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    ),
    PostEntity(
      id: 'post-2',
      authorName: 'Club Robotique',
      authorRoleLabel: 'Club',
      content: 'Notre prochaine session de démonstration aura lieu vendredi à 16h, amphi C. Ouvert à tous !',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      reactionCount: 12,
    ),
  ];

  final List<ActivityGroupEntity> _groups = [
    const ActivityGroupEntity(
      id: 'grp-club-1',
      name: 'Club Robotique',
      kind: GroupKind.club,
      memberCount: 34,
      description: 'Conception et compétitions de robots étudiants.',
    ),
    const ActivityGroupEntity(
      id: 'grp-club-2',
      name: 'Club Photographie',
      kind: GroupKind.club,
      memberCount: 21,
      description: 'Sorties photo et ateliers retouche.',
      isJoined: true,
    ),
    const ActivityGroupEntity(
      id: 'grp-class-1',
      name: 'L2 Info — Groupe A',
      kind: GroupKind.classe,
      memberCount: 30,
      description: 'Groupe classe officiel.',
      isJoined: true,
    ),
  ];

  @override
  Future<List<PostEntity>> getPosts() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _posts.where((p) => !p.isHidden).toList()
      ..sort((a, b) => b.postedAt.compareTo(a.postedAt));
  }

  @override
  Future<PostEntity> createPost(
    String content, {
    bool isOfficial = false,
  }) async {
    final post = PostEntity(
      id: const Uuid().v4(),
      authorName: 'Vous',
      authorRoleLabel: isOfficial ? 'Officiel' : 'Étudiant',
      content: content,
      postedAt: DateTime.now(),
      isOfficial: isOfficial,
    );
    _posts.insert(0, post);
    return post;
  }

  @override
  Future<void> toggleReaction(String postId) async {
    final i = _posts.indexWhere((p) => p.id == postId);
    if (i == -1) return;
    final p = _posts[i];
    _posts[i] = p.copyWith(
      hasReacted: !p.hasReacted,
      reactionCount: p.hasReacted ? p.reactionCount - 1 : p.reactionCount + 1,
    );
  }

  @override
  Future<void> addComment(String postId, String text) async {
    final i = _posts.indexWhere((p) => p.id == postId);
    if (i == -1) return;
    final p = _posts[i];
    final newComment = CommentEntity(
      id: const Uuid().v4(),
      authorName: 'Vous',
      text: text,
      postedAt: DateTime.now(),
    );
    _posts[i] = p.copyWith(comments: [...p.comments, newComment]);
  }

  @override
  Future<void> hidePost(String postId) async {
    final i = _posts.indexWhere((p) => p.id == postId);
    if (i != -1) _posts[i] = _posts[i].copyWith(isHidden: true);
  }

  @override
  Future<List<ActivityGroupEntity>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_groups);
  }

  @override
  Future<void> toggleJoinGroup(String groupId) async {
    final i = _groups.indexWhere((g) => g.id == groupId);
    if (i == -1) return;
    final g = _groups[i];
    _groups[i] = g.copyWith(
      isJoined: !g.isJoined,
      memberCount: g.isJoined ? g.memberCount - 1 : g.memberCount + 1,
    );
  }
}
