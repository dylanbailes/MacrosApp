// Path: providers/coach_providers.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The AI Coach feature (Blueprint §3.8).
///
/// The coach is a focused space to read the day's insight and ask follow-up
/// questions. There is no AI backend wired yet — the conversation is local:
/// [CoachNotifier] appends the user's question and replies with a canned,
/// keyword-matched answer so the full chat loop works in the demo. Swap
/// `_replyTo` for a real LLM call when the backend lands.
///
/// The [coachInsightProvider] is the **single source of truth** for the day's
/// insight — the Dashboard teaser card and the Coach screen's Insight Card
/// both read it, so a refresh here updates both.

/// The default insight shown when nothing has been generated yet.
const String defaultCoachInsight =
    'Your protein has been low 3 days running — want a suggestion?';

/// Rotating insight pool used by [CoachInsightNotifier.refresh].
const List<String> _insights = [
  defaultCoachInsight,
  'You hit your calorie target 4 of the last 7 days — consistency is building.',
  'Hydration is trending down this week. Small bumps compound fast.',
  'You averaged 7h of sleep on training days. Recovery drives progress — protect it.',
];

/// The current coach insight. Watched by both the Dashboard teaser card and
/// the Coach screen's Insight Card so they always agree.
final coachInsightProvider =
    NotifierProvider<CoachInsightNotifier, String>(CoachInsightNotifier.new);

class CoachInsightNotifier extends Notifier<String> {
  @override
  String build() => defaultCoachInsight;

  /// Cycles to the next insight (used by the Insight Card's refresh action).
  void refresh() {
    final idx = _insights.indexOf(state);
    state = _insights[(idx + 1) % _insights.length];
  }
}

/// Who sent a message in the coach conversation.
enum CoachAuthor { user, coach }

/// One message in the coach conversation.
class CoachMessage {
  const CoachMessage({
    required this.text,
    required this.author,
    this.sentAt,
  });

  final String text;
  final CoachAuthor author;

  /// Local send time; null for seeded messages.
  final DateTime? sentAt;
}

/// The coach conversation: messages plus a "coach is typing" flag.
class CoachState {
  const CoachState({required this.messages, this.isTyping = false});

  final List<CoachMessage> messages;

  /// True while the coach is "thinking" before replying.
  final bool isTyping;
}

/// The coach conversation state.
final coachProvider =
    NotifierProvider<CoachNotifier, CoachState>(CoachNotifier.new);

class CoachNotifier extends Notifier<CoachState> {
  Timer? _typingTimer;

  @override
  CoachState build() {
    ref.onDispose(() => _typingTimer?.cancel());
    return const CoachState(
      messages: [
        CoachMessage(
          text: 'Hey, I\'m your coach. Ask me about your protein, calories, '
              'hydration, sleep, or today\'s insight — I\'ll do my best.',
          author: CoachAuthor.coach,
        ),
      ],
    );
  }

  /// Appends the user's message and schedules a canned coach reply.
  ///
  /// Ignores blank input and messages sent while the coach is already typing.
  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || state.isTyping) return;

    state = CoachState(
      messages: [
        ...state.messages,
        CoachMessage(
            text: text, author: CoachAuthor.user, sentAt: DateTime.now()),
      ],
      isTyping: true,
    );

    // Simulate the coach "thinking" before replying. The timer is cancelled
    // in ref.onDispose, so this can never fire on a disposed notifier.
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 700), () {
      state = CoachState(
        messages: [
          ...state.messages,
          CoachMessage(
            text: _replyTo(text),
            author: CoachAuthor.coach,
            sentAt: DateTime.now(),
          ),
        ],
      );
    });
  }

  /// Local keyword-matched reply. Replace with a real AI call when wired.
  static String _replyTo(String question) {
    final q = question.toLowerCase();

    if (q.contains('protein')) {
      return 'Your protein has averaged about 110g — roughly 65% of your '
          '165g target. Try a 30g shake at breakfast or swap your lunch carb '
          'for a lean meat to close the gap without eating more.';
    }
    if (q.contains('water') || q.contains('hydrat')) {
      return 'You logged 1.4L against a 2.5L target. A 250ml glass with each '
          'meal plus one during training gets you most of the way there.';
    }
    if (q.contains('sleep') || q.contains('rest')) {
      return 'Aim for 7-8h on training days — that\'s when recovery and muscle '
          'synthesis actually happen. A consistent bedtime beats catch-up.';
    }
    if (q.contains('calorie') || q.contains('kcal') || q.contains('deficit')) {
      return 'You\'re averaging within ~200 kcal of your 2,200 target. For '
          'steady fat loss keep the weekly average under target rather than '
          'chasing perfect days.';
    }
    if (q.contains('carb')) {
      return 'Carbs are your primary training fuel. Around training, favour '
          'fast carbs; away from training, lean on whole grains and fruit.';
    }
    if (q.contains('fat') || q.contains('weight') || q.contains('lose')) {
      return 'Your trend is moving the right way — down ~1kg over the month. '
          'Hold the calorie target steady and the weight will follow.';
    }
    if (q.contains('meal') || q.contains('food') || q.contains('eat')) {
      return 'A high-protein, high-volume option: grilled chicken or tofu over '
          'a big salad with rice, plus a fruit on the side. Dense, fast, and '
          'satisfying.';
    }
    return 'Got it. Based on your recent logs, keep your protein consistent, '
        'stay near your calorie target, and protect your sleep. Small, steady '
        'wins compound — I\'m here when you need a second opinion.';
  }
}
