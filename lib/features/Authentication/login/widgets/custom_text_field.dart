import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String textFieldFor;
  final IconData iconData;
  final RegExp? regExp;

  const CustomTextField({
    super.key,
    required this.textFieldFor,
    required this.iconData,
    this.regExp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textFieldFor,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          inputFormatters: regExp != null
              ? [FilteringTextInputFormatter.allow(regExp!)]
              : [],
          decoration: InputDecoration(
            hintText: "Enter your ${textFieldFor.toLowerCase()}",
            hintStyle: const TextStyle(
              color: Colors.black38,
            ),
            prefixIcon: Icon(iconData),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
