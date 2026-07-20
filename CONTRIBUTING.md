# Contributing to Macro Tracker

Thank you for your interest in contributing to Macro Tracker! This document provides comprehensive guidelines for contributing to this open-source project.

## Project Philosophy

Before contributing, please understand our core principles:

### 1. Speed Above All

Every feature must prioritize speed and friction reduction. If your contribution adds taps, delays, or complexity without significant value, it will likely be rejected.

**Ask yourself:** Does this make logging faster or slower?

### 2. Premium Experience

The app must feel polished and professional. Half-baked features, inconsistent styling, or poor UX will not be accepted.

**Ask yourself:** Would I pay for an app with this quality?

### 3. Clean Architecture

We follow strict architectural patterns. Code that doesn't respect these patterns creates technical debt.

**Ask yourself:** Does this follow the architecture documented in ARCHITECTURE.md?

### 4. Documentation First

Features without documentation are incomplete. Every PR must include relevant documentation updates.

**Ask yourself:** Have I updated all affected documentation?

### 5. Open Source Mindset

Write code for others to read and maintain. Clear names, helpful comments, and logical structure are non-negotiable.

**Ask yourself:** Could another developer understand this in 5 minutes?

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.2.0
- Dart >= 3.2.0
- Git
- A code editor (VS Code, Android Studio, etc.)
- GitHub account

### Initial Setup

1. **Fork the repository**
   - Click "Fork" on the GitHub repository page
   - Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/macro_tracker.git
   cd macro_tracker
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/macro_tracker.git
   git fetch upstream
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run code generation** (if applicable)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Verify setup**
   ```bash
   flutter run
   flutter analyze
   flutter test
   ```

---

## Development Workflow

### Branch Naming

Branches must follow a clear naming convention:

```
<type>/<short-description>
```

**Types:**
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring (no behavior change)
- `test/` - Test additions or modifications
- `chore/` - Maintenance tasks
- `perf/` - Performance improvements

**Examples:**
```
feature/meal-templates
fix/dashboard-crash-on-empty-state
docs/update-architecture-diagrams
refactor/extract-food-search-widget
test/add-meal-logging-integration-tests
chore/update-dependencies
perf/optimize-image-loading
```

**Invalid Examples:**
```
patch-1
new-stuff
fixing-bugs
my-feature
```

### Commit Message Style

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation change
- `style`: Code style change (formatting, etc.)
- `refactor`: Code refactor
- `test`: Test changes
- `chore`: Build/config changes

**Subject:**
- Use imperative mood ("add" not "added")
- No period at the end
- Maximum 72 characters

**Examples:**
```
feat(meal-tracking): add meal templates feature

Implement meal templates allowing users to save and quickly apply
common meal combinations. Includes UI for creating, editing, and
deleting templates.

Closes #123

---

fix(dashboard): resolve crash when daily meals list is empty

Added null check and empty state widget for dashboard meal list.

Fixes #456

---

docs(architecture): update data flow diagrams

Updated sequence diagrams in ARCHITECTURE.md to reflect new
repository pattern implementation.
```

**Invalid Examples:**
```
fixed stuff
added feature
WIP
asdfasdf
```

### Pull Request Process

1. **Sync with upstream**
   ```bash
   git checkout main
   git fetch upstream
   git merge upstream/main
   git push origin main
   ```

2. **Create feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Develop your feature**
   - Follow coding standards (see below)
   - Write tests
   - Update documentation
   - Run analysis tools frequently

4. **Commit your changes**
   - Use conventional commits
   - Keep commits atomic (one logical change per commit)
   - Write meaningful commit messages

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Fill out the PR template completely

---

## Coding Standards

### General Rules

1. **Always declare return types**
   ```dart
   // ✅ Good
   Future<void> loadMeals() async { ... }
   
   // ❌ Bad
   loadMeals() async { ... }
   ```

2. **Prefer const constructors**
   ```dart
   // ✅ Good
   const MealCard(meal: meal);
   
   // ❌ Bad
   MealCard(meal: meal);
   ```

3. **Avoid print statements**
   ```dart
   // ✅ Good
   logger.d('Loading meals');
   
   // ❌ Bad
   print('Loading meals');
   ```

4. **Use meaningful names**
   ```dart
   // ✅ Good
   final totalDailyCalories = _calculateTotalCalories(meals);
   
   // ❌ Bad
   final total = _calc(meals);
   ```

5. **Single responsibility per class**
   - Classes should do ONE thing
   - Maximum ~200 lines per file (guideline)
   - Extract helper classes when needed

6. **No deprecated APIs**
   - Run `flutter analyze` regularly
   - Update deprecated code immediately

7. **No TODO comments**
   - Either implement properly or create a GitHub issue
   - TODOs become technical debt

### Architecture Expectations

1. **Follow Clean Architecture layers**
   - Domain layer: Pure business logic, no dependencies
   - Data layer: Repository implementations, external services
   - Presentation layer: UI, widgets, providers

2. **Feature-first organization**
   - All feature code in `/features/feature_name/`
   - Each feature has `data/`, `domain/`, `presentation/` subdirectories

3. **Repository pattern**
   - Domain defines interfaces
   - Data implements interfaces
   - Presentation uses interfaces only

4. **Immutable models**
   - Use `freezed` for immutable classes
   - No mutable state in domain entities

5. **Dependency injection via Riverpod**
   - All dependencies provided via providers
   - No manual instantiation of dependencies

### Testing Expectations

1. **Unit tests for use cases**
   ```dart
   group('GetMealsUseCase', () {
     test('returns meals when repository succeeds', () async {
       // Test implementation
     });
     
     test('returns failure when repository fails', () async {
       // Test implementation
     });
   });
   ```

2. **Widget tests for reusable components**
   ```dart
   testWidgets('AppCard displays child content', (tester) async {
     await tester.pumpWidget(const AppCard(child: Text('Test')));
     expect(find.text('Test'), findsOneWidget);
   });
   ```

3. **Integration tests for critical flows**
   ```dart
   testWidgets('User can log a meal', (tester) async {
     // Full integration test
   });
   ```

4. **Test file naming**
   - Mirror source structure
   - Add `_test.dart` suffix
   ```
   lib/features/meal_tracking/domain/usecases/get_meals.dart
   test/features/meal_tracking/domain/usecases/get_meals_test.dart
   ```

5. **Minimum coverage expectations**
   - New features: >80% line coverage
   - Critical paths: 100% coverage
   - Overall project: >70% coverage

### Documentation Requirements

1. **Public APIs must be documented**
   ```dart
   /// Calculates the total macronutrients for a given list of meals.
   ///
   /// Returns a [DailyMacros] object containing the sum of protein,
   /// carbohydrates, and fat across all provided meals.
   ///
   /// If [meals] is empty, returns [DailyMacros.zero].
   DailyMacros calculateDailyMacros(List<Meal> meals) { ... }
   ```

2. **Complex logic needs inline comments**
   ```dart
   // Macro calculation uses Atwater factors
   // Protein: 4 cal/g, Carbs: 4 cal/g, Fat: 9 cal/g
   final totalCalories = protein * 4 + carbs * 4 + fat * 9;
   ```

3. **Update ARCHITECTURE.md for structural changes**
   - New patterns require documentation
   - Diagrams must be updated
   - Examples should be provided

4. **Update ROADMAP.md when completing milestones**
   - Mark milestones as complete
   - Add completion date
   - Note any deviations from plan

5. **Update PRODUCT_SPEC.md for feature changes**
   - New features must be documented
   - Changed behavior must be noted
   - Non-goals may need updating

---

## Pull Request Checklist

Before submitting your PR, verify all items:

### Code Quality
- [ ] Code follows architecture patterns (ARCHITECTURE.md)
- [ ] No linting errors (`flutter analyze`)
- [ ] No deprecated API usage
- [ ] No print statements (use logger package)
- [ ] No TODO comments
- [ ] Meaningful variable and function names
- [ ] Single responsibility per class

### Testing
- [ ] Unit tests written for new use cases
- [ ] Widget tests for new components
- [ ] Integration tests for critical flows
- [ ] All existing tests pass (`flutter test`)
- [ ] Test coverage is acceptable

### Documentation
- [ ] Public APIs documented with doc comments
- [ ] Complex logic has inline comments
- [ ] ARCHITECTURE.md updated (if applicable)
- [ ] ROADMAP.md updated (if milestone completed)
- [ ] PRODUCT_SPEC.md updated (if feature changed)
- [ ] README.md updated (if applicable)

### Functionality
- [ ] Feature works as described in PR
- [ ] No regressions in existing features
- [ ] Tested on at least one platform
- [ ] Edge cases handled
- [ ] Error states handled gracefully
- [ ] Loading states implemented

### Design
- [ ] UI matches design system
- [ ] Dark mode only (no light mode code)
- [ ] Consistent spacing (8pt grid)
- [ ] Proper typography hierarchy
- [ ] Animations are smooth (60fps)
- [ ] Touch targets ≥ 48x48dp

### Git Hygiene
- [ ] Branch name follows convention
- [ ] Commits use conventional commits format
- [ ] Commits are atomic and logical
- [ ] Branch is up to date with main
- [ ] No merge commits (rebase if needed)

---

## Review Process

### What Happens After Submission

1. **Automated checks run**
   - CI pipeline executes
   - Tests run automatically
   - Linting checks performed
   - Build verification

2. **Maintainer review**
   - Code review by project maintainers
   - Architecture compliance check
   - Design consistency review
   - Feedback provided within 1 week

3. **Revision cycle**
   - Address reviewer feedback
   - Push additional commits
   - Request re-review

4. **Merge decision**
   - Approved: Merged to main
   - Changes requested: Revise and resubmit
   - Rejected: With explanation

### Review Criteria

Reviewers evaluate PRs based on:

| Criterion | Weight | Description |
|-----------|--------|-------------|
| Architecture Compliance | High | Follows documented patterns |
| Code Quality | High | Clean, readable, maintainable |
| Test Coverage | High | Adequate tests for changes |
| Documentation | Medium | Properly documented |
| Design Consistency | Medium | Matches design system |
| Performance | Medium | No performance degradation |
| User Impact | Variable | Positive user experience |

### Common Reasons for Rejection

1. **Architecture violations**
   - Business logic in presentation layer
   - Direct API calls from widgets
   - Circular dependencies between layers

2. **Code quality issues**
   - Unclear naming
   - Large methods (>50 lines)
   - Duplicated code
   - Missing error handling

3. **Insufficient testing**
   - No tests for new features
   - Tests don't cover edge cases
   - Broken existing tests

4. **Documentation gaps**
   - Undocumented public APIs
   - Outdated architecture docs
   - Missing usage examples

5. **Design inconsistencies**
   - Hardcoded colors or spacing
   - Inconsistent typography
   - Poor touch targets

6. **Scope creep**
   - Multiple unrelated changes
   - Features beyond PR description
   - Personal preferences vs requirements

---

## Communication

### Where to Discuss

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Questions, ideas, community
- **PR Comments**: Specific to code changes
- **Discord/Slack** (if available): Real-time chat

### How to Ask for Help

1. **Search first**
   - Check existing issues
   - Read documentation
   - Search discussions

2. **Provide context**
   - What are you trying to accomplish?
   - What have you tried?
   - What's the expected vs actual result?

3. **Include details**
   - Flutter version
   - Platform you're developing on
   - Relevant code snippets
   - Error messages (full stack trace)

### Response Times

- Bug reports: 1-3 days
- Feature requests: 1 week
- PR reviews: 1 week
- Questions: 1-3 days

---

## Code of Conduct

### Our Pledge

We pledge to make participation in this project a harassment-free experience for everyone, regardless of:

- Age, body size, disability
- Ethnicity, gender identity/expression
- Level of experience, education
- Nationality, personal appearance
- Race, religion, sexual identity/orientation

### Expected Behavior

- Use welcoming and inclusive language
- Be respectful of differing viewpoints
- Gracefully accept constructive criticism
- Focus on what's best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Trolling, insulting comments, personal attacks
- Public or private harassment
- Publishing others' private information
- Other conduct inappropriate in professional settings

### Enforcement

Violations will result in:
1. Warning
2. Temporary ban
3. Permanent ban

Report violations to project maintainers.

---

## Recognition

Contributors are recognized through:

- **README.md**: List of contributors
- **Release notes**: Mention of significant contributions
- **GitHub**: Contribution graph and stats
- **Social media**: Shout-outs for major features

---

## Legal

### License

By contributing, you agree that your contributions will be licensed under the project's license (to be determined).

### Copyright

You retain copyright of your contributions but grant the project a perpetual, royalty-free license to use, modify, and distribute your work.

---

## Questions?

If you have questions not covered by this guide:

1. Check the [FAQ](#) (if available)
2. Search existing issues/discussions
3. Create a new discussion post
4. Contact maintainers directly

---

**Thank you for contributing to Macro Tracker!** 🎉

Your efforts help make this project better for everyone. We appreciate your time, expertise, and enthusiasm.
