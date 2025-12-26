import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

class AuthForm extends StatefulWidget {
  final String buttonText;
  final bool isLoading;
  final Function(String email, String password) onSubmitted;

  const AuthForm({
    Key? key,
    required this.buttonText,
    required this.isLoading,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmitted(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: AppStrings.emailLabel,
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            enabled: !widget.isLoading,
            validator: (val) =>
                (val == null || !val.contains('@')) ? 'Email invalide' : null,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: AppStrings.passwordLabel,
              prefixIcon: Icon(Icons.lock_outlined),
            ),
            obscureText: true,
            enabled: !widget.isLoading,
            validator: (val) =>
                (val == null || val.length < 6) ? 'Min 6 caractères' : null,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(widget.buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
