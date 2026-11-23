import 'package:flutter/material.dart';
import '../api/api_exception.dart';

class AsyncStateView extends StatelessWidget {
  const AsyncStateView({super.key, required this.onRetry, this.error, this.loading = false});
  final VoidCallback onRetry;
  final Object? error;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    final message = switch (error) {
      NoConnectionException() => 'Offline. Connect and try again.',
      UnauthorizedException() => 'Your session expired. Please sign in.',
      NotFoundException() => 'The requested item is gone.',
      ServerException(:final status) => 'Server error $status. Please retry.',
      BadResponseException() => 'Invalid data from the server.',
      RequestException(:final message) => message,
      _ => 'Something went wrong. Please retry.',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off_outlined, size: 46),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
        ]),
      ),
    );
  }
}
