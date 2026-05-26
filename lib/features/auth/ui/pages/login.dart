import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => _loading = true);
  //   try {
  //     await widget.onSubmit(_email.text.trim(), _password.text);
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
  //   } finally {
  //     if (mounted) setState(() => _loading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        automaticallyImplyActions: false,
        title: Text(
          'Welcome back',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    (v?.contains('@') ?? false) ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (v) =>
                    (v?.length ?? 0) >= 6 ? null : 'Password is too short',
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {},
                  child: _loading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text('Sign in'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  /* navigate to signup */
                },
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
