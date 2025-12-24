import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports based on your corrected structure
import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_form.dart'; // Corrected path
import '../../../../routes/route_names.dart'; // Assuming you have this defined

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Architect's Note: We use Consumer to listen to state changes efficiently.
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        // Listener for Side Effects (Navigation/Snackbars)
        // Note: In a real app, you might use a dedicated package or mixin
        // to handle one-time events to avoid showing the snackbar multiple times during rebuilds.
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
            // Navigate to Home and remove back stack so user can't swipe back to login
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
                    // 1. Logo & Header
                    const Icon(
                      Icons.health_and_safety,
                      size: 80,
                      color: Colors.blue, // Use AppColors.primary later
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to manage your health',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 48),

                    // 2. The Reusable Auth Form
                    AuthForm(
                      buttonText: 'Sign In',
                      isLoading: viewModel.status.isLoading,
                      onSubmitted: (email, password) {
                        viewModel.login(email, password);
                      },
                    ),

                    const SizedBox(height: 24),

                    // 3. Register Link
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
