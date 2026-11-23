import 'package:flutter/material.dart';
import '../../../core/navigation/app_routes.dart';
import '../models/reading_book.dart';

class ReadingEntryTile extends StatelessWidget {
  const ReadingEntryTile({super.key, required this.readingBook});
  final ReadingBook readingBook;

  @override
  Widget build(BuildContext context) {
    final entry = readingBook.entry;
    return Card(child: InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.entryDetails, arguments: readingBook),
      borderRadius: BorderRadius.circular(12),
      child: Padding(padding: const EdgeInsets.all(14), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.book_outlined), const SizedBox(width: 12),
            Expanded(child: Text(readingBook.title, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium)),
            const Icon(Icons.chevron_right),
          ]),
          const SizedBox(height: 6),
          Text('${entry.status.label} · ${entry.pagesRead}/${entry.totalPages} pages'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: readingBook.progress / 100),
        ],
      )),
    ));
  }
}
