import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    Key? key,
    required this.hint,
    required this.keyboardType,
    required this.onChanged,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
    required this.validator,
  }) : super(key: key);

  final String hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        textfieldBackground(),
        Container(
          padding: EdgeInsets.only(bottom: 10.h, left: 20.w, top: 15.h),
          width: 269.w,
          height: 48.h,
          child: textfieldBody(theme, context),
        )
      ],
    );
  }

  TextFormField textfieldBody(ThemeData theme, BuildContext context) {
    return TextFormField(
        cursorColor: theme.primaryColor,
        style: theme.textTheme.headline4,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onEditingComplete: () => FocusManager.instance.primaryFocus?.unfocus(),
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? Icon(
                  Icons.visibility_off_outlined,
                  size: 20.r,
                  color: theme.primaryColor,
                )
              : null,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: const Color(0x73C4C4C4)), //TODO: color
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: hint,
        ));
  }

  SizedBox textfieldBackground() {
    return SizedBox(
      width: 289.w,
      height: 60.h,
      child: Image.asset(
        'assets/images/textfield.png',
        fit: BoxFit.fill,
      ),
    );
  }
}
