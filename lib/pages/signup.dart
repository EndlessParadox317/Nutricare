import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/randomutilities/errordisplay.dart';
import 'package:nutricare/randomutilities/text_field_input.dart';


import '../randomutilities/pickimage.dart';

import 'home.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  bool _isImageLoading = true;

  @override
  void initState() {
    super.initState();
    loadDefaultImage();
  }

  Future<void> loadDefaultImage() async {
    try {
      setState(() {
        _isImageLoading = true;
      });
      final ByteData imageData = await rootBundle.load('assets/default_avatar.png');
      final Uint8List bytes = imageData.buffer.asUint8List();
      setState(() {
        _image = bytes;
        _isImageLoading = false;
      });
    } catch (e) {
      print('Exception caught while loading default image: $e');
      setState(() {
        _isImageLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authentication().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      age: int.parse(_ageController.text),
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.pushReplacementNamed(context, '/Home');

    }
  }

  void navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/Login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 2),
                  const SizedBox(height: 30),
                  //circular widget to accept and show our selected file
                  if (_isImageLoading)
                    CircularProgressIndicator() // Show loading indicator while image is loading
                  else
                  Stack(
                    children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: _image != null ? MemoryImage(_image!) : null,
                            // Optional: Provide a fallback widget for when _image is null
                            child: _image == null ? CircularProgressIndicator() : null,
                      ),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                          ))
                    ],
                  ),
                  const SizedBox(height: 24),
                  //text field input for username
                  TextFieldInput(
                      textEditingController: _usernameController,
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text),
                  const SizedBox(height: 24),
                  //text field input for email
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(height: 24),
                  //text field input for password
                  TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      isPass: true),
                  const SizedBox(height: 24),
                  TextFieldInput(
                      textEditingController: _ageController,
                      hintText: 'Enter your age',
                      textInputType: TextInputType.text),
                  const SizedBox(height: 24),
                  //button login
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: Colors.blue),
                      child: _isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                          : const Text('Sign up'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(child: Container(), flex: 2),

                  //transition to signing up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Don't have an account?"),
                      ),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text("Login.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ))),
    );
  }
}
