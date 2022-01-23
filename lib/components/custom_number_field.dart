import 'package:flutter/material.dart';

class CustomNumberFormField extends StatelessWidget {
  const CustomNumberFormField(
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
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        cursorColor: Colors.white70,
        // focusNode: viewModel.nameFocusNode,
        controller: fieldController,
        validator: (String? val) {
          if (val == null || val == "") {
            return "Enter valid value!";
          } else if (int.tryParse(val)! < 0) {
            return "Value cannot be less than 0";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: fieldTitle,
          hintText: fieldHint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
        // onFieldSubmitted: (value) {
        //   viewModel.nameFocusNode.unfocus();
        //   FocusScope.of(context).requestFocus(viewModel.phoneNumberFocusNode);
        // },
      ),
    );
  }

  customTextFormField(
    String fieldTitle,
    TextEditingController fieldController,
    String fieldHint,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white70),
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        cursorColor: Colors.white70,
        // focusNode: viewModel.nameFocusNode,
        controller: fieldController,

        decoration: InputDecoration(
          labelText: fieldTitle,
          hintText: fieldHint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "Field cannot be empty";
          }
        },
        // onFieldSubmitted: (value) {
        //   viewModel.nameFocusNode.unfocus();
        //   FocusScope.of(context).requestFocus(viewModel.phoneNumberFocusNode);
        // },
      ),
    );
  }
}
