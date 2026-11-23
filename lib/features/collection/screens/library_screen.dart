import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/load_status.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../models/reading_status.dart';
import '../providers/reading_provider.dart';
import '../widgets/reading_entry_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Library'), actions: [
      IconButton(tooltip: 'Refresh library', icon: const Icon(Icons.refresh),
        onPressed: () => context.read<ReadingProvider>().load()),
    ]),
    body: Column(children: [
      const _LibraryFilters(),
      Expanded(child: const _LibraryResults()),
    ]),
  );
}

class _LibraryFilters extends StatelessWidget {
  const _LibraryFilters();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReadingProvider>();
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        _chip(context, state, null, 'All'),
        for (final status in ReadingStatus.values) _chip(context, state, status, status.label),
      ])),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        const Text('Sort: '),
        DropdownButton<LibrarySort>(value: state.sort, items: const [
          DropdownMenuItem(value: LibrarySort.title, child: Text('Title')),
          DropdownMenuItem(value: LibrarySort.progress, child: Text('Progress')),
        ], onChanged: (value) {
          if (value != null) context.read<ReadingProvider>().setSort(value);
        }),
      ]),
    ]));
  }

  Widget _chip(BuildContext context, ReadingProvider state, ReadingStatus? value, String label) =>
      Padding(padding: const EdgeInsets.only(right: 6), child: FilterChip(
        label: Text(label), selected: state.filter == value,
        onSelected: (_) => context.read<ReadingProvider>().setFilter(value),
      ));
}

class _LibraryResults extends StatelessWidget {
  const _LibraryResults();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReadingProvider>();
    Future<void> retry() => context.read<ReadingProvider>().load();
    return switch (state.status) {
      LoadStatus.initial || LoadStatus.loading => AsyncStateView(onRetry: retry, loading: true),
      LoadStatus.error => AsyncStateView(onRetry: retry, error: state.error),
      LoadStatus.empty => EmptyStateView(message: 'Your library is empty. Explore the catalogue to add a book.',
        actionLabel: 'Refresh library', onAction: retry),
      LoadStatus.data => _collection(context, state),
    };
  }

  Widget _collection(BuildContext context, ReadingProvider state) {
    final filtered = state.visibleItems;
    if (filtered.isEmpty) {
      return EmptyStateView(message: 'No books in this category.', actionLabel: 'Clear filter',
        onAction: () => context.read<ReadingProvider>().setFilter(null));
    }
    return RefreshIndicator(onRefresh: () => context.read<ReadingProvider>().load(),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return GridView.builder(padding: const EdgeInsets.all(12), itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 420, mainAxisExtent: 154, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemBuilder: (context, i) => ReadingEntryTile(readingBook: filtered[i]));
        }
        return ListView.builder(padding: const EdgeInsets.all(12), itemCount: filtered.length,
          itemBuilder: (context, i) => ReadingEntryTile(readingBook: filtered[i]));
      }));
  }
}
