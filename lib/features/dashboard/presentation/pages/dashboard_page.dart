import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

/// Dashboard page - Main overview of daily macros and progress.
/// 
/// This page displays:
/// - Daily macro summary (protein, carbs, fat)
/// - Calorie tracking
/// - Progress charts (future)
/// - Quick actions for meal logging
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh functionality will be implemented later
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              _buildDateHeader(),
              
              const SizedBox(height: 24),
              
              // Macro Summary Cards
              _buildMacroSummary(context),
              
              const SizedBox(height: 24),
              
              // Calorie Progress
              _buildCalorieProgress(context),
              
              const SizedBox(height: 24),
              
              // Quick Stats Grid
              _buildQuickStats(context),
              
              const SizedBox(height: 32),
              
              // Placeholder message
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.construction_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'More features coming soon',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    final now = DateTime.now();
    final dayName = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][now.weekday - 1];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dayName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${now.day}/${now.month}/${now.year}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Macros',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _MacroCard(label: 'Protein', value: '0g', color: Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _MacroCard(label: 'Carbs', value: '0g', color: Colors.orange)),
            const SizedBox(width: 12),
            Expanded(child: _MacroCard(label: 'Fat', value: '0g', color: Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildCalorieProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calories',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '0 / 2000 kcal',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                  backgroundColor: AppColors.divider,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(label: 'Meals', value: '0')),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: 'Water', value: '0L')),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: 'Weight', value: '--')),
          ],
        ),
      ],
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
