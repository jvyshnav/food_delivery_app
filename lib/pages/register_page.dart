import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_button.dart';
import 'package:food_delivery_app/components/mytextfield.dart';
import 'package:food_delivery_app/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordcontroller =
      TextEditingController();

  //register method
  void register() async {
    //get auth service
    final _authService = AuthService();
    //check if password match
    if (passwordController.text == confirmPasswordcontroller.text) {
      try {
        await _authService.signUpWithEmailPassword(
            emailController.text, passwordController.text);
      }
      //display any errors
      catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //if password don't match
    else{
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("password doesn't match"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_open,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 20),
            Text("Let's Create An Account For You",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 30)),
            const SizedBox(height: 20),
            MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController),
            const SizedBox(height: 20),
            MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController),
            const SizedBox(height: 20),
            MyTextField(
                hintText: "ConfirmPassword",
                obscureText: true,
                controller: confirmPasswordcontroller),
            const SizedBox(height: 20),
            MyButton(text: "Sign Up", onTap:register),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already HAve an Account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Sign Up Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
