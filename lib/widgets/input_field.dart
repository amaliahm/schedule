import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.background,
                          width: 0
                        )
                      ),
                      enabledBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.background,
                          width: 0
                        )
                      ),
                    ),
                  ),
                ),
                widget == null ? Container() :
                Container(
                  child: widget,
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get titleStyle {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  TextStyle get subTitleStyle {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
      ),
    );
  }
}
