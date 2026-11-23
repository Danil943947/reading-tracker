import 'package:flutter/material.dart';

class BookSearchField extends StatelessWidget {
  const BookSearchField({super.key, required this.controller, required this.onChanged,
    required this.onSubmitted});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: 'Search titles or authors',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
