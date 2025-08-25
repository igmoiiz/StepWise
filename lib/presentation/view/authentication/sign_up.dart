import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stepwise/presentation/utilities/components/custom_animated_button.dart';
import 'package:stepwise/presentation/utilities/components/custom_input_field.dart';
import 'package:stepwise/presentation/utilities/components/validation_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
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

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

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
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
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
                      controller: _nameController,
                      validator: ValidationHelper.validateName,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 24),

                    CustomInputField(
                      label: 'Email',
                      hint: 'Enter your email address',
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      validator: ValidationHelper.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),

                    CustomInputField(
                      label: 'Password',
                      hint: 'Create a password',
                      icon: Icons.lock_outlined,
                      isPassword: true,
                      controller: _passwordController,
                      validator: ValidationHelper.validatePassword,
                    ),

                    const SizedBox(height: 24),

                    CustomInputField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      icon: Icons.lock_outlined,
                      isPassword: true,
                      controller: _confirmPasswordController,
                      validator: (value) =>
                          ValidationHelper.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                    ),

                    const SizedBox(height: 24),

                    // Terms and Conditions Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() => _agreeToTerms = value ?? false);
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
                      isLoading: _isLoading,
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
