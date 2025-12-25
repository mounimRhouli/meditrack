import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_form.dart';
import 'widgets/social_login_buttons.dart'; // <--- 1. Import the new widget
import '../../../../routes/route_names.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        // ... (Error and Success handling remains the same) ...
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

        if (viewModel.status.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, AppRouteNames.home);
          });
        }

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Section
                    const Icon(
                      Icons.health_and_safety,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 48),

                    // Main Form
                    AuthForm(
                      buttonText: 'Sign In',
                      isLoading: viewModel.status.isLoading,
                      onSubmitted: (email, password) {
                        viewModel.login(email, password);
                      },
                    ),

                    const SizedBox(height: 24),

                    // <--- 2. INTEGRATION POINT: Social Buttons
                    SocialLoginButtons(
                      isLoading: viewModel.status.isLoading,
                      onGooglePressed: () {
                        // Future Todo: viewModel.loginWithGoogle();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Google Login coming soon!"),
                          ),
                        );
                      },
                      onApplePressed: () {
                        // Future Todo: viewModel.loginWithApple();
                      },
                    ),

                    const SizedBox(height: 24),

                    // Footer Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteNames.register,
                            );
                          },
                          child: const Text('Register'),
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
