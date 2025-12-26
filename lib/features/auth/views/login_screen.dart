import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_form.dart';
import 'widgets/social_login_buttons.dart';
import '../../../../routes/route_names.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        // ... (Error/Success handling remains identical to your file)

        return Scaffold(
          // Background color handled by AppTheme
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
                      color: Theme.of(context).primaryColor, // Use Theme
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      AppStrings.welcomeBack,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 48),

                    AuthForm(
                      buttonText: AppStrings.signIn,
                      isLoading: viewModel.isLoading,
                      onSubmitted: (email, password) =>
                          viewModel.login(email, password),
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    SocialLoginButtons(
                      isLoading: viewModel.isLoading,
                      onGooglePressed: () {},
                      onApplePressed: () {},
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.dontHaveAccount),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteNames.register,
                            );
                          },
                          child: const Text(AppStrings.register),
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
