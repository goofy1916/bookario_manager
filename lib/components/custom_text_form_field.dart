import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.fieldController,
      required this.fieldTitle,
      required this.fieldHint})
      : super(key: key);

  final TextEditingController fieldController;
  final String fieldTitle;
  final String fieldHint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white70),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        cursorColor: Colors.white70,
        // focusNode: viewModel.nameFocusNode,
        controller: fieldController,
        validator: (String? val) {
          if (val == null || val == "") {
            return "Enter valid value!";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: fieldTitle,
          hintText: fieldHint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
