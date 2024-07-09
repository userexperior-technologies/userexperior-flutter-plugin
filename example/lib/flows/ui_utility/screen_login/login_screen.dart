import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/flows/ui_utility/screen_login/provider/login_provider.dart';
import 'package:user_experior_example/utilities/app_assets.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Expanded(
              child: _logoImage(context),
            ),
            const Text('Sign In', style: TextStyle(fontSize: 30)),
            Expanded(
              child: _textFields(context),
            ),
            Expanded(
              child: SizedBox(
                height: 30,
                child: _nextButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<LoginProvider>(context, listen: false)
                  .loginPressed(context);
            },
            style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.all(14)),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
                backgroundColor: const WidgetStatePropertyAll(Colors.amber)),
            child: const Text('Sign In', style: TextStyle(fontSize: 20)),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _textFields(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, provider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: provider.emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(15)),
                labelText: 'Email'),
            onChanged: (_) {
              provider.setIsError(false);
            },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: provider.passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              labelText: 'password',
            ),
            onChanged: (_) {
              provider.setIsError(false);
            },
          ),
          if (provider.isError) _loginError(),
        ],
      );
    });
  }

  Widget _logoImage(BuildContext context) {
    return Center(
      child: Image.asset(
        AppIcons.logoImage,
        width: 0.4 * MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget _loginError() {
    return const Text('Error loging in, Please provide email and password',
        style: errorStyle);
  }
}
