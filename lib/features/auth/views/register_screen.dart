import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_form.dart';
// Note: We assume RouteNames are available via the other developer's work
import '../../../../routes/route_names.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        // 1. Error Handling
        if (viewModel.status.isError && viewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(viewModel.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        // 2. Success Handling
        if (viewModel.status.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // On success, go to Home (or Onboarding if you have one)
            Navigator.pushReplacementNamed(context, AppRouteNames.home);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Account'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Join MediTrack',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start your health journey today',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 48),

                    // 3. Reusing the AuthForm
                    // Notice we pass a different button text and method
                    AuthForm(
                      buttonText: 'Register',
                      isLoading: viewModel.status.isLoading,
                      onSubmitted: (email, password) {
                        viewModel.register(email, password);
                      },
                    ),

                    const SizedBox(height: 24),

                    // 4. Back to Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Go back to Login
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
