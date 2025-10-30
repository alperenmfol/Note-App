import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/validator/validators.dart';
import 'package:note_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:note_app/features/auth/presentation/cubit/obscure_cubit.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Sign in...")));
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Welcome! ${state.user.fullName}")),
          );

          // Örneğin ana sayfaya yönlendirme
          context.goNamed("notes-list-page");
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Hello\nSign in!",
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: "MontserratBold",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
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
                                "Email",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily: "MontserratSemiBold",
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.validateEmail,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                ),
                              ),

                              const SizedBox(height: 24),

                              Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
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

                              const SizedBox(height: 16),

                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    context.pushNamed("notes-list-page");
                                  },
                                  child: const Text(
                                    "Forgot password?",
                                    style: TextStyle(
                                      fontFamily: "MontserratSemiBold",
                                    ),
                                  ),
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    final email = emailController.text.trim();
                                    final password =
                                        passwordController.text.trim();

                                    // Cubit çağrısı
                                    context.read<AuthCubit>().login(
                                      email,
                                      password,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          "Lütfen tüm alanları doğru doldurun",
                                          style: TextStyle(
                                            fontFamily: "MontserratSemiBold",
                                          ),
                                        ),
                                        backgroundColor:
                                            Theme.of(context).colorScheme.error,
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
                                  "SIGN IN",
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                    fontSize: 16,
                                    fontFamily: "MontserratBold",
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
                                        "sign-up-page",
                                      );
                                    },
                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(
                                        fontFamily: "MontserratSemiBold",
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
      ),
    );
  }
}
