import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(
      {Key? key,
      required this.hintText,
      required this.icon,
      required this.keyboardType,
      required this.obscureText,
      this.vvalidator,
      required this.fillcolor,
      this.suffixIcon,
      required this.textInputAction,
      this.controllerr,
      this.maxLength,
      this.onChanged})
      : super(key: key);
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? vvalidator;
  final Color fillcolor;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final TextEditingController? controllerr;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      validator: vvalidator,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: suffixIcon,
        fillColor: fillcolor,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black54)),
      ),
      controller: controllerr,
      maxLength: maxLength,
      onChanged: onChanged,
    );
  }
}
