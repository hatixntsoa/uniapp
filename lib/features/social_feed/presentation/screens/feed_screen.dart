import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
// import '../../../auth/presentation/providers/auth_provider.dart';
// import '../../domain/entities/post_entity.dart';
import '../providers/social_feed_providers.dart';
import 'group_list_screen.dart';
import 'chat_screen.dart';
import 'post_detail_screen.dart';

/// Ticket: Gp6-3 — news feed (post, official highlight, reactions, comments, moderation)
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _composerCtrl = TextEditingController();

  @override
  void dispose() {
    _composerCtrl.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    if (_composerCtrl.text.trim().isEmpty) return;
    await ref
        .read(postListProvider.notifier)
        .createPost(_composerCtrl.text.trim());
    _composerCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postListProvider);
    final df = DateFormat('dd/MM HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réseau universitaire'),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GroupListScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ChatScreen())),
          ),
        ],
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (posts) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              const SectionHeader(
                eyebrow: 'Communauté',
                title: 'Fil d\'actualité',
              ),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _composerCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Partagez une actualité...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _post,
                        child: const Text('Publier'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (posts.isEmpty)
                Text('Aucun élément à afficher', style: AppTextStyles.bodyMuted)
              else
                for (final p in posts) ...[
                  AppCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostDetailScreen(post: p),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.accentSoft,
                              child: Text(
                                p.authorName.substring(0, 1),
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.authorName,
                                    style: AppTextStyles.cardTitle,
                                  ),
                                  Text(
                                    df.format(p.postedAt),
                                    style: AppTextStyles.label,
                                  ),
                                ],
                              ),
                            ),
                            if (p.isOfficial)
                              const PillBadge(
                                label: 'Officiel',
                                color: AppColors.accent,
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(p.content, style: AppTextStyles.body),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                p.hasReacted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: p.hasReacted
                                    ? AppColors.danger
                                    : AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () => ref
                                  .read(postListProvider.notifier)
                                  .toggleReaction(p.id),
                            ),
                            Text(
                              '${p.reactionCount}',
                              style: AppTextStyles.bodyMuted,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            const Icon(
                              Icons.mode_comment_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${p.comments.length}',
                              style: AppTextStyles.bodyMuted,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          );
        },
      ),
    );
  }
}
