import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Expanded(flex: 30, child: SizedBox()),
              Icon(Icons.event_note_outlined, size: 100),
              Text(
                "Note It",
                style: TextStyle(fontSize: 50, fontFamily: "MontserratBold"),
              ),
              Expanded(flex: 30, child: SizedBox()),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 30, fontFamily: "MontserratBold"),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed("sign-in-page");
                },
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(
                    Size(double.infinity, 60),
                  ),
                ),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "MontserratBold",
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed("sign-up-page");
                },
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(
                    Size(double.infinity, 60),
                  ),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "MontserratBold",
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Expanded(flex: 40, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
