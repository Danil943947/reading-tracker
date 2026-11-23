import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/load_status.dart';
import '../../../core/widgets/async_state_view.dart';
import '../providers/reading_provider.dart';
import '../widgets/statistics_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReadingProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Reading statistics')),
      body: state.status == LoadStatus.error
          ? AsyncStateView(error: state.error, onRetry: () => context.read<ReadingProvider>().load())
          : state.status == LoadStatus.loading || state.status == LoadStatus.initial
              ? const Center(child: CircularProgressIndicator())
              : ListView(padding: const EdgeInsets.all(16), children: [
                  Text('Your reading journey', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 18),
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    StatisticsCard(label: 'Total books', value: '${state.totalBooks}', icon: Icons.library_books_outlined),
                    StatisticsCard(label: 'Completed', value: '${state.completedBooks}', icon: Icons.check_circle_outline),
                    StatisticsCard(label: 'In progress', value: '${state.readingBooks}', icon: Icons.auto_stories_outlined),
                  ]),
                  const SizedBox(height: 24),
                  Text('Overall progress', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: state.overallProgress / 100, minHeight: 12),
                  const SizedBox(height: 10),
                  Text('${state.overallProgress.toStringAsFixed(0)}% of recorded pages read'),
                ]),
    );
  }
}
