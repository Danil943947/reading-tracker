import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/navigation/app_routes.dart';
import '../../collection/providers/reading_provider.dart';
import '../models/book.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key, required this.book});
  final Book book;

  Future<void> _openLink(BuildContext context) async {
    final uri = Uri.https('openlibrary.org', book.id);
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open the link.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open the link.')));
      }
    }
  }

  Future<void> _add(BuildContext context) async {
    final saved = await Navigator.pushNamed(context, AppRoutes.entryForm, arguments: book);
    if (saved != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book added to My Library.')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Book details')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Center(child: Container(width: 148, height: 180,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.auto_stories, size: 80))),
      const SizedBox(height: 20),
      Text(book.title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
      const SizedBox(height: 6),
      Text(book.authors.map((a) => a.name).join(', '), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      Wrap(spacing: 8, children: [
        Chip(label: Text(book.firstPublishYear?.toString() ?? 'Year unknown')),
        if (book.language case final String language) Chip(label: Text(language)),
      ]),
      const SizedBox(height: 12),
      Text('About this book', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text(book.description ?? 'No description available.'),
      const SizedBox(height: 14),
      Wrap(spacing: 6, children: book.subjects.map((s) => Chip(label: Text(s))).toList()),
      const SizedBox(height: 20),
      // select rebuilds only this button when the collection changes.
      _AddToLibraryButton(onAdd: () => _add(context), bookId: book.id),
      TextButton.icon(onPressed: () => _openLink(context),
        icon: const Icon(Icons.open_in_new), label: const Text('View on Open Library')),
    ]),
  );
}

class _AddToLibraryButton extends StatelessWidget {
  const _AddToLibraryButton({required this.bookId, required this.onAdd});
  final String bookId;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final alreadySaved = context.select<ReadingProvider, bool>((p) => p.containsBook(bookId));
    return FilledButton.icon(
      onPressed: alreadySaved ? null : onAdd,
      icon: Icon(alreadySaved ? Icons.check_circle_outline : Icons.bookmark_add_outlined),
      label: Text(alreadySaved ? 'Already in My Library' : 'Add to My Library'),
    );
  }
}
