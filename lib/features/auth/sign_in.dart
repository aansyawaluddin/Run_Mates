import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/main_page.dart';
import 'package:runmates/providers/auth_provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 60,
                            icon: Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 100),
                          Expanded(
                            child: Text(
                              'Selamat Datang',
                              style: AppTextStyles.heading2(
                                weight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ).copyWith(height: 1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 96.0),

                      // Field Email
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@gmail.com')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: AppColors.textSecondary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Field Kata Sandi
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi wajib diisi';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi minimal 6 karakter';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Kata Sandi',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: AppColors.textSecondary,

                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    String? error = await context
                                        .read<AuthProvider>()
                                        .login(
                                          _emailController.text,
                                          _passwordController.text,
                                        );

                                    if (context.mounted) {
                                      if (error == null) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPage(),
                                          ),
                                          (route) => false,
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  AppColors.textSecondary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              title: Text(
                                                'Gagal Masuk',
                                                style: AppTextStyles.heading4(
                                                  weight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              content: Text(
                                                error,
                                                style:
                                                    AppTextStyles.heading4Uppercase(
                                                      weight: FontWeight.normal,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                              ),
                                              actions: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 45,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Coba Lagi',
                                                      style:
                                                          AppTextStyles.button(
                                                            weight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  }
                                },

                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Masuk',
                            style: AppTextStyles.button(
                              weight: FontWeight.bold,
                              color: AppColors.bgLight,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32.0),

                      // Divider OR
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.primary,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Atau',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.primary,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Center(
                        child: Text(
                          'Masuk Dengan',
                          style: AppTextStyles.heading4Uppercase(
                            weight: FontWeight.normal,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Center(
                        child: Container(
                          width: 250,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              print('Sign up with Google');
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.textSecondary,
                              side: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/google.png',
                                  height: 24.0,
                                  width: 24.0,
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  'Sign in with Google',
                                  style: AppTextStyles.button(
                                    weight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (authProvider.isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.textPrimary),
            ),
        ],
      ),
    );
  }
}
