import 'package:flutter/material.dart';
import 'package:schedule/main.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primaryClr,
          ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        )
      ),
    );
  }
}
