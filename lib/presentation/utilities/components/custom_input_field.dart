// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField>
    with SingleTickerProviderStateMixin {
  bool _isObscured = true;
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  colorScheme.onSurface.withOpacity(0.8),
                  colorScheme.onSurface.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _isFocused
                    ? colorScheme.primary.withOpacity(0.5)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _isObscured : false,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              onTap: () {
                setState(() => _isFocused = true);
                _animationController.forward();
              },
              onTapOutside: (event) {
                setState(() => _isFocused = false);
                _animationController.reverse();
              },
              style: GoogleFonts.urbanist(
                color: colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                prefixIcon: Icon(
                  widget.icon,
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onTertiary,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _isObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colorScheme.onTertiary,
                        ),
                        onPressed: () {
                          setState(() => _isObscured = !_isObscured);
                        },
                      )
                    : null,
                labelStyle: GoogleFonts.urbanist(
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onTertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                hintStyle: GoogleFonts.urbanist(
                  color: colorScheme.onTertiary.withOpacity(0.7),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }
}
