import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../routes/route_names.dart';
import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_form.dart';
import 'widgets/social_login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.status.isError && viewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(viewModel.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
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
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      AppStrings.welcomeBack,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 48),

                    AuthForm(
                      buttonText: AppStrings.signInAction,
                      isLoading: viewModel.status.isLoading,
                      onSubmitted: (email, password) {
                        viewModel.login(email, password);
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    SocialLoginButtons(
                      isLoading: viewModel.status.isLoading,
                      onGooglePressed: () {}, // Todo
                      onApplePressed: () {}, // Todo
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.noAccount),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteNames.register,
                            );
                          },
                          child: const Text(AppStrings.registerAction),
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
