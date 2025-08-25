// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stepwise/core/components/failure/faliure_bar.dart';
import 'package:stepwise/core/components/success/success_bar.dart';
import 'package:stepwise/core/controller/authentication/auth_controller.dart';
import 'package:stepwise/core/controller/controllers.dart';
import 'package:stepwise/presentation/utilities/components/custom_animated_button.dart';
import 'package:stepwise/presentation/utilities/components/custom_input_field.dart';
import 'package:stepwise/presentation/utilities/navigation/elegant_route.dart';
import 'package:stepwise/presentation/view/authentication/forgot_password.dart';
import 'package:stepwise/presentation/view/authentication/sign_up.dart';
import 'package:stepwise/presentation/view/interface/interface.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  //  Instance for controllers
  final Controllers _controllers = Controllers();

  //  Instance for authentication controller
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();

    _controllers.fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _controllers.slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _controllers.fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controllers.fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _controllers.slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controllers.slideController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations
    _controllers.fadeController.forward();
    _controllers.slideController.forward();
  }

  //  Dispose all the controllers after use
  @override
  void dispose() {
    _controllers.fadeController.dispose();
    _controllers.slideController.dispose();
    _controllers.emailController.dispose();
    _controllers.passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() async {
    if (_controllers.formKey.currentState!.validate()) {
      setState(() => _controllers.isLoading = true);

      // Simulate login process
      await Future.delayed(const Duration(seconds: 2), () {
        //  Signup authentication flow
        _authController
            .signInWithEmailPassword(
              _controllers.emailController.text,
              _controllers.passwordController.text,
              context,
            )
            .then((value) {
              Navigator.of(
                context,
              ).pushReplacement(elegantRoute(const InterfacePage()));
              successBar(context: context, message: "Signed in Successfully");
            })
            .onError((error, stackTrace) {
              faliureBar(
                context: context,
                message:
                    "Error While Signing in Please Try again Later: $error",
              );
            });
      });

      setState(() => _controllers.isLoading = false);

      // Show success message or navigate
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login successful!',
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    Navigator.of(context).push(elegantRoute(ForgotPasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _controllers.fadeAnimation,
          child: SlideTransition(
            position: _controllers.slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _controllers.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    // Welcome Header
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.urbanist(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue to your account',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: colorScheme.onTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Email Field
                    CustomInputField(
                      label: 'Email',
                      hint: 'Enter your email address',
                      icon: Icons.email_outlined,
                      controller: _controllers.emailController,
                      validator: _validateEmail,
                    ),

                    const SizedBox(height: 24),

                    // Password Field
                    CustomInputField(
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_outlined,
                      isPassword: true,
                      controller: _controllers.passwordController,
                      validator: _validatePassword,
                    ),

                    const SizedBox(height: 16),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _handleForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.urbanist(
                            color: colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Login Button
                    CustomAnimatedButton(
                      text: 'Sign In',
                      onPressed: _handleLogin,
                      isLoading: _controllers.isLoading,
                    ),

                    const SizedBox(height: 32),

                    // Sign Up Link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: colorScheme.onTertiary,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to sign up
                                  Navigator.of(
                                    context,
                                  ).push(elegantRoute(const SignUpPage()));
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.urbanist(
                                    color: colorScheme.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
