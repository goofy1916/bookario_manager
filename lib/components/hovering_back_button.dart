import 'package:flutter/material.dart';

class HoveringBackButton extends StatelessWidget {
  const HoveringBackButton({
    Key? key,
    this.back,
  }) : super(key: key);

  final Function()? back;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () => back ?? Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.only(left: 12, top: 16),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white54,
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
