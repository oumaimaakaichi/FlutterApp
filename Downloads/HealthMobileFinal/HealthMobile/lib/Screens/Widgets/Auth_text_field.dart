import 'package:flutter/material.dart';

class Auth_text_field extends StatelessWidget {
  final String text;
  final String icon;
  final TextEditingController controller;
  final String? Function(String?)? validator; // Making the validator parameter optional
  final bool obscureText; // Adding obscureText parameter

  Auth_text_field({
    required this.text,
    required this.icon,
    required this.controller,
    this.validator, // Update the constructor to accept an optional validator
    this.obscureText = false, // Setting default value for obscureText
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.none,
          obscureText: obscureText, // Using the provided obscureText value
          keyboardType: TextInputType.emailAddress,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            focusColor: Colors.black26,
            fillColor: Color.fromARGB(255, 247, 247, 247),
            filled: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Container(
                child: Image.asset(icon),
              ),
            ),
            prefixIconColor: const Color.fromARGB(255, 3, 190, 150),
            labelText: text, // Using labelText instead of label
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          validator: validator, // Assigning the provided validator to the TextFormField
        ),
      ),
    );
  }
}
