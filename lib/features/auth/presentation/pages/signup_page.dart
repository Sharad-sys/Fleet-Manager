import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tester/features/auth/cubit/auth_state.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/signup_form_cubit.dart';
import '../../validation/email.dart';
import '../../validation/password.dart';
import '../../validation/name.dart';
import '../../constants/auth_constants.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupFormCubit(),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            print('SignupPage: Auth state changed to: $state');
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AuthAuthenticated) {
              print('SignupPage: Signup successful, user: ${state.user}');
              // Navigate to home after successful signup
              context.go('/home');
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Title
                    Icon(
                      Icons.person_add_alt_1,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Name Field
                    BlocBuilder<SignupFormCubit, SignupFormState>(
                      buildWhen: (previous, current) =>
                          previous.name != current.name,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter your name',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            errorText: state.name.displayError != null
                                ? _getNameErrorMessage(state.name.error)
                                : null,
                          ),
                          onChanged: (value) {
                            context.read<SignupFormCubit>().nameChanged(value);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    BlocBuilder<SignupFormCubit, SignupFormState>(
                      buildWhen: (previous, current) =>
                          previous.email != current.email,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            errorText: state.email.displayError != null
                                ? _getEmailErrorMessage(state.email.error)
                                : null,
                          ),
                          onChanged: (value) {
                            context.read<SignupFormCubit>().emailChanged(value);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    BlocBuilder<SignupFormCubit, SignupFormState>(
                      buildWhen: (previous, current) =>
                          previous.password != current.password,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            errorText: state.password.displayError != null
                                ? _getPasswordErrorMessage(state.password.error)
                                : null,
                          ),
                          onChanged: (value) {
                            context.read<SignupFormCubit>().passwordChanged(
                              value,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Signup Button
                    BlocBuilder<SignupFormCubit, SignupFormState>(
                      buildWhen: (previous, current) =>
                          previous.isValid != current.isValid,
                      builder: (context, formState) {
                        return BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, authState) {
                            return ElevatedButton(
                              onPressed:
                                  formState.isValid && authState is! AuthLoading
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().signup(
                                          _nameController.text.trim(),
                                          _emailController.text.trim(),
                                          _passwordController.text,
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: authState is AuthLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _getNameErrorMessage(NameValidationError? error) {
    switch (error) {
      case NameValidationError.empty:
        return AuthConstants.nameRequired;
      case NameValidationError.tooShort:
        return AuthConstants.nameMinLength;
      default:
        return null;
    }
  }

  String? _getEmailErrorMessage(EmailValidationError? error) {
    switch (error) {
      case EmailValidationError.empty:
        return AuthConstants.emailRequired;
      case EmailValidationError.invalid:
        return AuthConstants.emailInvalid;
      default:
        return null;
    }
  }

  String? _getPasswordErrorMessage(PasswordValidationError? error) {
    switch (error) {
      case PasswordValidationError.empty:
        return AuthConstants.passwordRequired;
      case PasswordValidationError.tooShort:
        return AuthConstants.passwordMinLength;
      default:
        return null;
    }
  }
}
