// Path: pages/coach_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../providers/coach_providers.dart';
import '../widgets/coach_composer.dart';
import '../widgets/coach_insight_card.dart';
import '../widgets/message_bubble.dart';

/// AI Coach screen (Blueprint §3.8).
///
/// A focused space to read the day's insight and ask follow-up questions:
///
/// - Header: back arrow + "Coach" title (pushed over the shell)
/// - Insight Card: hero card with the full insight (expanded dashboard teaser)
/// - Conversation: left/right message bubbles ([MessageBubble])
/// - Composer: pinned pill input + send button ([CoachComposer])
///
/// Tablet: content is capped at 640px and centered; the composer stays pinned
/// to the bottom above the safe area.
class CoachPage extends ConsumerWidget {
  const CoachPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insight = ref.watch(coachInsightProvider);
    final conversation = ref.watch(coachProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                // ── Header: back arrow + title ───────────────────────────
                AppScreenHeader(
                  title: 'Coach',
                  leading: AppButton(
                    key: const Key('coach-back'),
                    onPressed: () => context.pop(),
                    icon: Icons.arrow_back,
                    variant: AppButtonVariant.icon,
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.sm,
                    AppSpacing.xl,
                    AppSpacing.none,
                  ),
                ),

                // ── Scrollable conversation ──────────────────────────────
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.sm,
                      AppSpacing.xl,
                      AppSpacing.lg,
                    ),
                    children: [
                      CoachInsightCard(
                        insight: insight,
                        onRefresh: () =>
                            ref.read(coachInsightProvider.notifier).refresh(),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      // The provider always seeds a welcome message, so the
                      // conversation is never empty once built.
                      ...[
                        for (final message in conversation.messages) ...[
                          MessageBubble(
                            text: message.text,
                            isUser: message.author == CoachAuthor.user,
                          ),
                          // 16px conversational rhythm between bubbles
                          // (Blueprint §3.8 — layout).
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        if (conversation.isTyping) ...[
                          const _TypingBubble(),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ],
                    ],
                  ),
                ),

                // ── Pinned composer ──────────────────────────────────────
                const CoachComposer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A quiet left-aligned bubble that appears while the coach is composing.
class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: AppSkeleton(
          width: 96,
          height: 40,
          borderRadius: 20,
        ),
      ),
    );
  }
}
