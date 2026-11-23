import 'package:flutter/material.dart';
import '../../../core/navigation/app_routes.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.bookDetails, arguments: book),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 66, height: 94,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.auto_stories,
              color: Theme.of(context).colorScheme.onPrimaryContainer, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 7),
              Text(book.firstPublishYear?.toString() ?? 'Year unknown',
                style: Theme.of(context).textTheme.bodySmall),
            ],
          )),
          const Icon(Icons.chevron_right),
        ]),
      ),
    ),
  );
}
