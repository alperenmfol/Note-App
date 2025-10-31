import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/validator/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/obscure_cubit.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.goNamed("main-navigation-page");
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Create Your\nAccount!",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "MontserratBold",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Full Name",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: "MontserratSemiBold",
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: nameController,
                              validator: Validators.validateName,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: "Enter your name",
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: "MontserratSemiBold",
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: emailController,
                              validator: Validators.validateEmail,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: "Enter your email",
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: "MontserratSemiBold",
                              ),
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<ObscureCubit, bool>(
                              builder: (context, state) {
                                return TextFormField(
                                  controller: passwordController,
                                  validator: Validators.validatePassword,
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        context
                                            .read<ObscureCubit>()
                                            .toggleObscure();
                                      },
                                      icon: Icon(
                                        state
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                  obscureText: state,
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: "MontserratSemiBold",
                              ),
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<ObscureCubit, bool>(
                              builder: (context, state) {
                                return TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: state,
                                  validator:
                                      (value) =>
                                          Validators.validateConfirmPassword(
                                            value,
                                            passwordController.text,
                                          ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    hintText: "Enter your password again",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        context
                                            .read<ObscureCubit>()
                                            .toggleObscure();
                                      },
                                      icon: Icon(
                                        state
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Form validasyonunu kontrol et
                                  if (formKey.currentState!.validate()) {
                                    // Tüm alanlar geçerli
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Creating account for ${emailController.text}',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    await context.read<AuthCubit>().register(
                                      emailController.text,
                                      passwordController.text,
                                      nameController.text,
                                    );
                                  } else {
                                    //Validasyon hatası var
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill all fields correctly',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  minimumSize: WidgetStatePropertyAll(
                                    Size(double.infinity, 60),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                    fontSize: 16,
                                    fontFamily: "MontserratBold",
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have account?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.pushReplacementNamed(
                                      "sign-in-page",
                                    );
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontFamily: "MontserratSemiBold",
                                      color: Theme.of(context).colorScheme.secondary,
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
            ],
          ),
        ),
      ),
    );
  }
}
