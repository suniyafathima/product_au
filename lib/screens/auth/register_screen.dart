import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Firebase authentication state will automatically
      // take the user to HomeScreen.
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message =
              'An account already exists with this email.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'weak-password':
          message =
              'Password is too weak. Use at least 6 characters.';
          break;

        case 'network-request-failed':
          message =
              'Please check your internet connection.';
          break;

        case 'operation-not-allowed':
          message =
              'Email/password authentication is not enabled.';
          break;

        default:
          message =
              'Something went wrong. Please try again.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE5DDF7),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF8B5CF6),
                                Color(0xFF6D28D9),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          'Create Account',
                          style: GoogleFonts.manrope(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          'Create your account and start learning',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      _label('Email address'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailController,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration: _inputDecoration(
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter your email';
                          }

                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _label('Password'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          hint: 'Create a password',
                          icon: Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF888888),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _label('Confirm password'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller:
                            _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: _inputDecoration(
                          hint: 'Confirm your password',
                          icon: Icons.lock_reset_outlined,
                        ).copyWith(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF888888),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }

                          if (value !=
                              _passwordController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF8B5CF6),
                                Color(0xFF6D28D9),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent,
                              shadowColor: Colors.transparent,
                              disabledBackgroundColor:
                                  Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Create Account',
                                    style: GoogleFonts.manrope(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Center(
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: const Color(0xFF666666),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Login',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      const Color(0xFF6D28D9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF333333),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(
        fontSize: 13,
        color: const Color(0xFFAAAAAA),
      ),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: const Color(0xFF8B5CF6),
      ),
      filled: true,
      fillColor: const Color(0xFFFAF9FD),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5DDF7),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5DDF7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF8B5CF6),
          width: 1.5,
        ),
      ),
    );
  }
}