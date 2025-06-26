import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tester/features/auth/cubit/auth_state.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/login_form_cubit.dart';
import '../../validation/email.dart';
import '../../validation/password.dart';
import '../../constants/auth_constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormCubit(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
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
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else if (state is AuthAuthenticated) {
              context.go('/home');
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your account',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    BlocBuilder<LoginFormCubit, LoginFormState>(
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
                            errorText: state.email.displayError != null
                                ? _getEmailErrorMessage(state.email.error)
                                : null,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onChanged: (value) {
                            context.read<LoginFormCubit>().emailChanged(value);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<LoginFormCubit, LoginFormState>(
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
                            errorText: state.password.displayError != null
                                ? _getPasswordErrorMessage(state.password.error)
                                : null,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onChanged: (value) {
                            context.read<LoginFormCubit>().passwordChanged(
                              value,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<LoginFormCubit, LoginFormState>(
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
                                        context.read<AuthCubit>().login(
                                          _emailController.text.trim(),
                                          _passwordController.text,
                                        );
                                      }
                                    }
                                  : null,
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
                                      'Sign In',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
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
