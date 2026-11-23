import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../catalogue/models/book.dart';
import '../models/reading_entry.dart';
import '../models/reading_status.dart';
import '../providers/reading_provider.dart';

class ReadingEntryFormScreen extends StatefulWidget {
  const ReadingEntryFormScreen({super.key, required this.book, this.existing});
  final Book book;
  final ReadingEntry? existing;
  @override
  State<ReadingEntryFormScreen> createState() => _ReadingEntryFormScreenState();
}

class _ReadingEntryFormScreenState extends State<ReadingEntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pages;
  late final TextEditingController _total;
  late final TextEditingController _rating;
  late final TextEditingController _notes;
  late final TextEditingController _startText;
  late final TextEditingController _finishText;
  late ReadingStatus _status;
  DateTime? _startDate;
  DateTime? _finishDate;
  bool _dirty = false;
  bool _saving = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.existing;
    _pages = TextEditingController(text: '${entry?.pagesRead ?? 0}');
    _total = TextEditingController(text: '${entry?.totalPages ?? 300}');
    _rating = TextEditingController(text: entry?.rating?.toString() ?? '');
    _notes = TextEditingController(text: entry?.notes ?? '');
    _startDate = entry?.startDate;
    _finishDate = entry?.finishDate;
    _startText = TextEditingController(text: _dateLabel(_startDate));
    _finishText = TextEditingController(text: _dateLabel(_finishDate));
    _status = entry?.status ?? ReadingStatus.wantToRead;
    for (final controller in [_pages, _total, _rating, _notes]) {
      controller.addListener(_markDirty);
    }
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  @override
  void dispose() {
    for (final controller in [_pages, _total, _rating, _notes, _startText, _finishText]) {
      controller.dispose();
    }
    super.dispose();
  }

  String _dateLabel(DateTime? date) => date == null ? '' :
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _chooseDate({required bool start}) async {
    final current = start ? _startDate : _finishDate;
    final selected = await showDatePicker(
      context: context, firstDate: DateTime(1900), lastDate: DateTime(2100),
      initialDate: current ?? DateTime.now(),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _dirty = true;
      if (start) { _startDate = selected; _startText.text = _dateLabel(selected); }
      else { _finishDate = selected; _finishText.text = _dateLabel(selected); }
    });
  }

  Future<void> _save() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final old = widget.existing;
    final draft = ReadingEntry(
      id: old?.id ?? '', bookId: widget.book.id, title: widget.book.title,
      status: _status, pagesRead: int.parse(_pages.text.trim()),
      totalPages: int.parse(_total.text.trim()),
      rating: _rating.text.trim().isEmpty ? null : int.parse(_rating.text.trim()),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      startDate: _startDate, finishDate: _finishDate,
    );
    if (draft.validationError case final String problem) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(problem)));
      return;
    }
    final provider = context.read<ReadingProvider>();
    final saved = await provider.save(draft, editing: old != null);
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${provider.error}')));
    } else {
      setState(() => _allowPop = true);
      Navigator.pop(context, saved);
    }
  }

  Future<void> _confirmExit(bool didPop) async {
    if (didPop || _saving) return;
    final leave = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Discard changes?'),
      content: const Text('Your unsaved changes will be lost.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Keep editing')),
        FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Discard')),
      ],
    ));
    if (leave == true && mounted) {
      setState(() => _allowPop = true);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_dirty && !_saving || _allowPop,
    onPopInvokedWithResult: (didPop, _) => _confirmExit(didPop),
    child: Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Add to My Library' : 'Edit reading entry')),
      body: Form(key: _formKey, autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Text(widget.book.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          ..._entryFields(),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: _saving ? null : _save,
            icon: _saving ? const SizedBox(height: 18, width: 18,
              child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined),
            label: Text(_saving ? 'Saving...' : 'Save entry')),
        ])),
    ),
  );

  List<Widget> _entryFields() => [
    DropdownButtonFormField<ReadingStatus>(
      initialValue: _status,
      decoration: const InputDecoration(labelText: 'Reading status', border: OutlineInputBorder()),
      items: ReadingStatus.values.map((status) =>
        DropdownMenuItem(value: status, child: Text(status.label))).toList(),
      onChanged: _saving ? null : (value) {
        if (value != null) setState(() { _status = value; _dirty = true; });
      },
    ),
    const SizedBox(height: 12),
    _numberField(_total, 'Total pages', (value) {
      final n = int.tryParse(value ?? '');
      if (n == null || n <= 0) return 'Enter a number greater than zero';
      return null;
    }),
    const SizedBox(height: 12),
    _numberField(_pages, 'Pages read', (value) {
      final n = int.tryParse(value ?? '');
      final total = int.tryParse(_total.text.trim());
      if (n == null || n < 0) return 'Enter a valid number';
      if (total != null && n > total) return 'Cannot exceed total pages';
      return null;
    }),
    const SizedBox(height: 12),
    _numberField(_rating, 'Rating (optional, 1–5)', (value) {
      if (value == null || value.trim().isEmpty) return null;
      final n = int.tryParse(value);
      if (n == null || n < 1 || n > 5) return 'Rating must be between 1 and 5';
      return null;
    }),
    const SizedBox(height: 12),
    TextFormField(controller: _notes, maxLines: 3,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
      onTapOutside: (_) => FocusScope.of(context).unfocus()),
    const SizedBox(height: 12),
    _dateField(_startText, 'Start date', true),
    const SizedBox(height: 12),
    _dateField(_finishText, 'Finish date', false),
  ];

  Widget _numberField(TextEditingController controller, String label,
    String? Function(String?) validator) => TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: validator,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );

  Widget _dateField(TextEditingController controller, String label, bool start) => TextFormField(
    controller: controller, readOnly: true,
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(),
      suffixIcon: IconButton(tooltip: 'Choose date', icon: const Icon(Icons.calendar_month),
        onPressed: () => _chooseDate(start: start))),
    onTap: () => _chooseDate(start: start),
    validator: (_) {
      final started = _startDate;
      final finished = _finishDate;
      if (!start && started != null && finished != null && finished.isBefore(started)) {
        return 'Finish must not precede start';
      }
      return null;
    },
  );
}
