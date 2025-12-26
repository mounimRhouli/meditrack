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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Veuillez entrer un email';
    if (!value.contains('@')) return 'Email invalide';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return 'Veuillez entrer un mot de passe';
    if (value.length < 6) return 'Minimum 6 caractères';
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmitted(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            // AppTheme handles the borders and fill color automatically!
            decoration: const InputDecoration(
              labelText: AppStrings.email,
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: AppStrings.password,
              prefixIcon: Icon(Icons.lock_outlined),
            ),
            obscureText: true,
            validator: _validatePassword,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              // AppTheme handles the primary color and border radius!
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
