/// Ticket: Gp6-3 — news feed post/announcement
class CommentEntity {
  const CommentEntity({
    required this.id,
    required this.authorName,
    required this.text,
    required this.postedAt,
  });
  final String id;
  final String authorName;
  final String text;
  final DateTime postedAt;
}

class PostEntity {
  const PostEntity({
    required this.id,
    required this.authorName,
    required this.authorRoleLabel,
    required this.content,
    required this.postedAt,
    this.isOfficial = false,
    this.reactionCount = 0,
    this.hasReacted = false,
    this.comments = const [],
    this.isHidden = false,
  });

  final String id;
  final String authorName;
  final String authorRoleLabel;
  final String content;
  final DateTime postedAt;
  final bool isOfficial;
  final int reactionCount;
  final bool hasReacted;
  final List<CommentEntity> comments;
  final bool isHidden;

  PostEntity copyWith({
    int? reactionCount,
    bool? hasReacted,
    List<CommentEntity>? comments,
    bool? isHidden,
  }) => PostEntity(
    id: id,
    authorName: authorName,
    authorRoleLabel: authorRoleLabel,
    content: content,
    postedAt: postedAt,
    isOfficial: isOfficial,
    reactionCount: reactionCount ?? this.reactionCount,
    hasReacted: hasReacted ?? this.hasReacted,
    comments: comments ?? this.comments,
    isHidden: isHidden ?? this.isHidden,
  );
}
