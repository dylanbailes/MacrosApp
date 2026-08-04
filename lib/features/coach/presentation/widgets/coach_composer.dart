// Path: widgets/coach_composer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/coach_providers.dart';

/// The AI Coach composer: a pill text input with a circular send button,
/// pinned to the bottom of the Coach screen.
///
/// Reference: Blueprint §3.8 — Composer (text input pill + send Icon Button)
/// Reuses the shared [AppTextField] shell (borderless inside the pill
/// container, which owns the border + fill).
class CoachComposer extends ConsumerStatefulWidget {
  const CoachComposer({super.key});

  @override
  ConsumerState<CoachComposer> createState() => _CoachComposerState();
}

class _CoachComposerState extends ConsumerState<CoachComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isReplying => ref.watch(coachProvider).isTyping;

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(coachProvider.notifier).send(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  void _onChanged(String value) {
    setState(() => _hasText = value.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    // The coach is replying — keep the field enabled but block sending so the
    // user can type ahead while the previous answer is composing.
    final canSend = _hasText && !_isReplying;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          border: Border.all(color: AppColors.dividerStrong),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppTextField(
                key: const Key('coach-composer-field'),
                controller: _controller,
                hintText: 'Ask your coach…',
                textInputAction: TextInputAction.send,
                minLines: 1,
                maxLines: 4,
                onChanged: _onChanged,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration.collapsed(
                  hintText: 'Ask your coach…',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              key: const Key('coach-send'),
              onPressed: canSend ? _send : null,
              icon: _isReplying ? Icons.more_horiz : Icons.arrow_upward,
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}
