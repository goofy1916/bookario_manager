import 'package:bookario_manager/components/constants.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key? key,
    required this.text,
    required this.function,
    required this.isActive,
  }) : super(key: key);

  final String text;
  final Function() function;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive ? kSecondaryColor : Colors.black,
          ),
          height: 40,
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
