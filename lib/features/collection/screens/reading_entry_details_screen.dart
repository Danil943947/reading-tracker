import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation/app_routes.dart';
import '../models/reading_book.dart';
import '../providers/reading_provider.dart';

class ReadingEntryDetailsScreen extends StatelessWidget {
  const ReadingEntryDetailsScreen({super.key, required this.readingBook});
  final ReadingBook readingBook;

  Future<void> _delete(BuildContext context) async {
    final yes = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Remove this book?'),
      content: const Text('This will delete your progress and notes.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
      ],
    ));
    if (yes != true || !context.mounted) return;
    final provider = context.read<ReadingProvider>();
    final ok = await provider.remove(readingBook.entry.id);
    if (!context.mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${provider.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = readingBook.entry;
    final busy = context.select<ReadingProvider, bool>((p) => p.isBusy);
    return Scaffold(
      appBar: AppBar(title: const Text('Reading details')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(readingBook.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(readingBook.author),
        const SizedBox(height: 18),
        Chip(label: Text(entry.status.label)),
        const SizedBox(height: 12),
        Text('Progress: ${entry.pagesRead} / ${entry.totalPages} pages'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: readingBook.progress / 100, minHeight: 9),
        const SizedBox(height: 6),
        Text('${readingBook.progress.toStringAsFixed(0)}% completed'),
        const SizedBox(height: 16),
        Text('Rating: ${entry.rating == null ? 'Not rated' : '${entry.rating}/5'}'),
        const SizedBox(height: 12),
        Text('Notes', style: Theme.of(context).textTheme.titleLarge),
        Text(entry.notes?.isNotEmpty == true ? (entry.notes ?? '') : 'No notes yet.'),
        const SizedBox(height: 12),
        Text('Started: ${_date(entry.startDate)}'),
        Text('Finished: ${_date(entry.finishDate)}'),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: busy ? null : () async {
          final result = await Navigator.pushNamed(context, AppRoutes.entryForm, arguments: readingBook);
          if (result != null && context.mounted) Navigator.pop(context);
        }, icon: const Icon(Icons.edit), label: const Text('Edit entry')),
        OutlinedButton.icon(onPressed: busy ? null : () => _delete(context),
          icon: const Icon(Icons.delete_outline), label: const Text('Delete entry')),
      ]),
    );
  }

  String _date(DateTime? date) => date == null ? 'Not set' :
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
