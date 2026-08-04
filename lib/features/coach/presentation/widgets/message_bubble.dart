// Path: widgets/message_bubble.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// One message bubble in the AI Coach conversation.
///
/// Reference: Blueprint §3.8 — Message Bubble (screen-unique)
///
/// - Coach bubbles: `surface.01` left-aligned
/// - User bubbles: `surface.02` right-aligned
/// - Both use `radius.md`, no avatars (a utility conversation, not a chat app)
/// - The bubble never exceeds ~80% of the available width so long replies
///   wrap cleanly while staying visually distinct from full-width cards.
///
/// Rendered on the shared [AppCard] shell (polish spec §8.5: "chat rows via
/// AppCard") with a static variant — bubbles are informational, not tappable.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.text,
    required this.isUser,
    super.key,
  });

  /// The message body.
  final String text;

  /// True for the user's own messages (right-aligned, elevated surface).
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: AppCard(
          variant: AppCardVariant.static,
          backgroundColor:
              isUser ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: AppBorderRadius.md,
          showBorder: false,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Text(
            text,
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ),
    );
  }
}
