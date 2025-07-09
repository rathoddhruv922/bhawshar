import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String? errorText;
  final String labelText, hintText;
  final TextEditingController textEditingController;
  final bool? isPasswordField, obscureText, isAutoFocus, readOnly;
  final int? maxLine, minLine;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final bool? isShowShadow;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final List<TextInputFormatter>? inputTextFormatter;
  final void Function(String)? onChanged;

  final String? Function(String?)? formValidator;
  final void Function(String?)? onFieldSubmit;
  final void Function()? onTap;
  const AppTextField({
    Key? key,
    this.errorText,
    required this.labelText,
    required this.hintText,
    this.isPasswordField = false,
    required this.textEditingController,
    this.formValidator,
    this.prefixIcon,
    this.keyboardType,
    this.inputTextFormatter,
    this.onChanged,
    this.fillColor,
    this.suffixIcon,
    this.isShowShadow = true,
    this.maxLine,
    this.focusNode,
    this.minLine,
    this.readOnly,
    this.obscureText,
    this.isAutoFocus = false,
    this.textInputAction,
    this.onFieldSubmit,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autocorrect: false,
      enableSuggestions: false,
      readOnly: readOnly ?? false,
      controller: textEditingController,
      style: Theme.of(context).textTheme.titleMedium!.merge(
            TextStyle(
              color: (readOnly ?? false) ? grey : textBlack,
            ),
          ),
      obscureText: obscureText ?? false,
      obscuringCharacter: '#',
      autofocus: isAutoFocus ?? false,
      textInputAction: textInputAction ?? TextInputAction.next,
      inputFormatters: inputTextFormatter ?? [],
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      maxLines: maxLine ?? 1,
      minLines: minLine ?? 1,
      onFieldSubmitted: onFieldSubmit,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        isDense: true,
        fillColor: fillColor ?? white,
        contentPadding:
            const EdgeInsets.only(top: 14.0, bottom: 8.0, left: 15, right: 15),
        labelText: labelText,
        hintText: hintText,
        errorMaxLines: 2,
        alignLabelWithHint: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        errorText: errorText,
        floatingLabelBehavior: isShowShadow == false
            ? FloatingLabelBehavior.never
            : FloatingLabelBehavior.always,
        border: isShowShadow == false
            ? OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(4))
            : DecoratedInputBorder(
                child: InputBorder.none,
                shadow: BoxShadow(
                  color: grey.withOpacity(0.2),
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: const Offset(0, 0.5),
                ),
              ),
        hintStyle: Theme.of(context).textTheme.titleMedium!.merge(
              TextStyle(
                color: textBlack.withOpacity(0.7),
                height: 1,
              ),
            ),
        errorStyle: Theme.of(context).textTheme.bodySmall!.merge(
              const TextStyle(color: errorRed, height: 0, fontSize: 15),
            ),
        labelStyle: Theme.of(context).textTheme.titleMedium!.merge(
              TextStyle(
                color: grey.withOpacity(1),
                fontWeight: FontWeight.bold,
                height: 1,
                fontSize: isShowShadow == false ? 14 : 18,
              ),
            ),
      ),
      validator: formValidator,
    );
  }
}
