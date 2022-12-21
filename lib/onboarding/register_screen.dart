import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/onboarding/auth.dart';

// inspired by AmirBayat0's responsive_login_signup_screens_flutter
// https://github.com/AmirBayat0/Responsive_login_signup_screens_flutter?ref=flutterawesome.com
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.15, // to be edited
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Register',
              style: GoogleFonts.ubuntu(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ), // size.height * 0.060
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// username or Gmail
                  TextFormField(
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  /// password
                  TextFormField(
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_open),
                      // suffixIcon: IconButton(
                      // icon: Icon(
                      // simpleUIController.isObscure.value
                      // ? Icons.visibility
                      // : Icons.visibility_off,
                      // ),
                      // onPressed: () {
                      // simpleUIController.isObscureActive();
                      // },
                      // ),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length < 6) {
                        return 'Password is at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),

                  /// Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (!(_formKey.currentState!.validate())) {
                          return;
                        }

                        try {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text('Registering...'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          await Auth().signUpWithEmail(
                              emailController.text, passwordController.text);
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(e.message ??
                                    'An error occurred while registering'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          return;
                        }

                        if (!mounted) return;
                        Navigator.pushNamed(context, '/');
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Successful registration.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                      },
                      child: Text(
                        'Register',
                        style: GoogleFonts.ubuntu(fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Back to ',
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'login',
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              color: Colors.deepPurpleAccent,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(context, '/'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Navigate To Login Screen
                  // GestureDetector(
                  // onTap: () {
                  // Navigator.pop(context);
                  // nameController.clear();
                  // emailController.clear();
                  // passwordController.clear();
                  // _formKey.currentState?.reset();
                  // simpleUIController.isObscure.value = true;
                  // },
                  // child: RichText(
                  // text: TextSpan(
                  // text: 'Don\'t have an account?',
                  // style: GoogleFonts.ubuntu(
                  // fontSize: 25,
                  // color: Colors.black,
                  // ),
                  // children: [
                  // TextSpan(
                  // text: " Sign up",
                  // style: GoogleFonts.ubuntu(
                  // fontSize: 25,
                  // fontWeight: FontWeight.w500,
                  // color: Colors.deepPurpleAccent,
                  // )),
                  // ],
                  // ),
                  // ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
