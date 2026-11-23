import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/load_status.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/book_search_field.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});
  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<BookProvider>().searchBooks('');
    });
  }

  void _queueSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) context.read<BookProvider>().searchBooks(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Discover books')),
    body: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Your next great read', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        BookSearchField(controller: _controller, onChanged: _queueSearch,
          onSubmitted: (value) {
            _debounce?.cancel();
            context.read<BookProvider>().searchBooks(value);
          }),
        const SizedBox(height: 12),
        Expanded(child: const _CatalogueResults()),
      ]),
    ),
  );
}

class _CatalogueResults extends StatelessWidget {
  const _CatalogueResults();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BookProvider>();
    Future<void> retry() => context.read<BookProvider>().refresh();
    return switch (state.status) {
      LoadStatus.initial || LoadStatus.loading =>
        AsyncStateView(onRetry: retry, loading: true),
      LoadStatus.error => AsyncStateView(onRetry: retry, error: state.error),
      LoadStatus.empty => EmptyStateView(message: 'No books match your search.',
        actionLabel: 'Show all books', onAction: () => context.read<BookProvider>().searchBooks('')),
      LoadStatus.data => RefreshIndicator(onRefresh: retry,
        child: LayoutBuilder(builder: (context, size) {
          final books = state.books;
          if (size.maxWidth >= 600) {
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: books.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 410, mainAxisExtent: 142,
                crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemBuilder: (context, index) => BookCard(book: books[index]),
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => BookCard(book: books[index]),
          );
        })),
    };
  }
}
