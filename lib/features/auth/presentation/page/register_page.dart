import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/components/my_button.dart';
import 'package:social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  void register() {
    final String email = emailController.text;
    final String name = nameController.text;
    final String confirmPassword = confirmPasswordController.text;
    final String password = passwordController.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();
    if (email.isNotEmpty &&
        name.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.register(email: email, password: password, name: name);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password does not match')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all field')));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.lock_open,
                  size: 80,
                  color: color.primary,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(color: color.primary, fontSize: 16),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obsecureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obsecureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obsecureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obsecureText: true),
                const SizedBox(
                  height: 25,
                ),
                MyButton(
                  text: 'Register',
                  onTap: () => register(),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an accout?, ',
                      style: TextStyle(color: color.primary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                            color: color.primary, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
