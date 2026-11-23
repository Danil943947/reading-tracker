import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../repositories/fake_auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: FakeAuthRepository.demoEmail);
  final _password = TextEditingController(text: FakeAuthRepository.demoPassword);

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_email.text.trim(), _password.text);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${auth.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthProvider>().isBusy;
    return Scaffold(body: SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(24), children: [
        Icon(Icons.auto_stories, size: 72, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text('Reading Tracker', textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Your personal reading space', textAlign: TextAlign.center),
        const SizedBox(height: 28),
        Form(key: _formKey, autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _password, obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              validator: (v) => v == null || v.length < 6 ? 'At least 6 characters' : null,
              onFieldSubmitted: (_) => _submit()),
          ])),
        const SizedBox(height: 18),
        FilledButton.icon(onPressed: busy ? null : _submit,
          icon: busy ? const SizedBox(width: 18, height: 18,
            child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login),
          label: Text(busy ? 'Signing in...' : 'Sign in')),
        const SizedBox(height: 20),
        const Text('Offline demo credentials are filled in. You can edit them to test login errors.',
          textAlign: TextAlign.center),
      ]),
    ))));
  }
}
