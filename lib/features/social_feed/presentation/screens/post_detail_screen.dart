import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/social_feed_providers.dart';

/// Ticket: Gp6-3 — post detail with comments + moderation (hide)
class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final PostEntity post;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Masquer (modération)',
            onPressed: () async {
              await ref
                  .read(postListProvider.notifier)
                  .hidePost(widget.post.id);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.authorName, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 6),
                  Text(widget.post.content, style: AppTextStyles.body),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Commentaires', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: widget.post.comments.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun élément à afficher',
                        style: AppTextStyles.bodyMuted,
                      ),
                    )
                  : ListView(
                      children: [
                        for (final c in widget.post.comments)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: AppCard(
                              padding: const EdgeInsets.all(12),
                              useShadow: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        c.authorName,
                                        style: AppTextStyles.label,
                                      ),
                                      const Spacer(),
                                      Text(
                                        df.format(c.postedAt),
                                        style: AppTextStyles.label,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(c.text, style: AppTextStyles.body),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Ajouter un commentaire...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.accent),
                  onPressed: () async {
                    if (_commentCtrl.text.trim().isEmpty) return;
                    await ref
                        .read(postListProvider.notifier)
                        .addComment(widget.post.id, _commentCtrl.text.trim());
                    _commentCtrl.clear();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
