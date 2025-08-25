// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stepwise/core/components/failure/faliure_bar.dart';
import 'package:stepwise/core/components/success/success_bar.dart';
import 'package:stepwise/core/controller/authentication/auth_controller.dart';
import 'package:stepwise/core/controller/controllers.dart';
import 'package:stepwise/presentation/utilities/components/custom_animated_button.dart';
import 'package:stepwise/presentation/utilities/components/custom_input_field.dart';
import 'package:stepwise/presentation/utilities/components/validation_helper.dart';
import 'package:stepwise/presentation/utilities/navigation/elegant_route.dart';
import 'package:stepwise/presentation/view/authentication/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  //  Instance for controllers for variable management
  final Controllers _controllers = Controllers();

  //  Instance for authentication controller
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
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

    _controllers.fadeController.forward();
    _controllers.slideController.forward();
  }

  //  Dispose the controllers after use for better life cycle of the application
  @override
  void dispose() {
    _controllers.fadeController.dispose();
    _controllers.slideController.dispose();
    _controllers.nameController.dispose();
    _controllers.emailController.dispose();
    _controllers.passwordController.dispose();
    _controllers.confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_controllers.formKey.currentState!.validate()) {
      if (!_controllers.agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please agree to the terms and conditions',
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      setState(() => _controllers.isLoading = true);
      await Future.delayed(const Duration(seconds: 2), () {
        //  Signup logic
        _authController
            .signUpWithEmailPassword(
              _controllers.emailController.text,
              _controllers.passwordController.text,
              context,
            )
            .then((value) {
              Navigator.of(
                context,
              ).pushReplacement(elegantRoute(const LoginPage()));
              successBar(
                context: context,
                message:
                    "Signed up Successfully. Please Login to see new content",
              );
            })
            .onError((error, stackTrace) {
              faliureBar(
                context: context,
                message:
                    "Error While Signing up Please Try again Later: $error",
              );
            });
      });
      setState(() => _controllers.isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account created successfully!',
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    const SizedBox(height: 20),

                    Text(
                      'Create Account',
                      style: GoogleFonts.urbanist(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started with your new account',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: colorScheme.onTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 40),

                    CustomInputField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outlined,
                      controller: _controllers.nameController,
                      validator: ValidationHelper.validateName,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 24),

                    CustomInputField(
                      label: 'Email',
                      hint: 'Enter your email address',
                      icon: Icons.email_outlined,
                      controller: _controllers.emailController,
                      validator: ValidationHelper.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),

                    CustomInputField(
                      label: 'Password',
                      hint: 'Create a password',
                      icon: Icons.lock_outlined,
                      isPassword: true,
                      controller: _controllers.passwordController,
                      validator: ValidationHelper.validatePassword,
                    ),

                    const SizedBox(height: 24),

                    CustomInputField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      icon: Icons.lock_outlined,
                      isPassword: true,
                      controller: _controllers.confirmPasswordController,
                      validator: (value) =>
                          ValidationHelper.validateConfirmPassword(
                            value,
                            _controllers.passwordController.text,
                          ),
                    ),

                    const SizedBox(height: 24),

                    // Terms and Conditions Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _controllers.agreeToTerms,
                          onChanged: (value) {
                            setState(
                              () => _controllers.agreeToTerms = value ?? false,
                            );
                          },
                          activeColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: colorScheme.onTertiary,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: GoogleFonts.urbanist(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.urbanist(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    CustomAnimatedButton(
                      text: 'Create Account',
                      onPressed: _handleSignUp,
                      isLoading: _controllers.isLoading,
                    ),

                    const SizedBox(height: 32),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: colorScheme.onTertiary,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Sign In',
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
