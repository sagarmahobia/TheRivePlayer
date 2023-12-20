import 'package:flutter/material.dart';
import 'package:the_rive_player/utils/mini_pallete.dart';

class TheDropDown<T> extends StatelessWidget {
  final T? value;

  final ValueChanged<T?>? onChanged;
  final List<T> items;
  final String hint;

  final IconData? icon;
  final VoidCallback? onTapIcon;
  final Color? iconColor;
  final bool enabled;
  final String? label;

  const TheDropDown({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.hint,
    this.enabled = true,
    this.icon,
    this.label,
    this.onTapIcon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ).copyWith(right: 11),
          hintText: hint,
          suffixIcon: icon != null
              ? InkWell(
                  onTap: onTapIcon,
                  child: Icon(
                    icon,
                    size: 20,
                    color: iconColor ?? Palette.light,
                  ),
                )
              : null,
          hintStyle: getTxt().copyWith(
            color: Palette.light,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          alignLabelWithHint: true,
          labelText: label,
          labelStyle: getTxt().copyWith(
            fontSize: 14,
            color: Palette.light,
            fontWeight: FontWeight.normal,
          ),

          floatingLabelStyle: getTxt().copyWith(
            fontSize: 14,
            color: Palette.light,
            fontWeight: FontWeight.normal,
          ),
          isDense: true,
          counterText: "",
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Palette.light,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Palette.light,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Palette.light,
              width: 1.0,
            ),
          ),
          // enabled: enabled,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Palette.errorColor,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Palette.errorColor,
              width: 1.0,
            ),
          ),

          errorMaxLines: 1,
          errorStyle: getTxt().copyWith(
            color: Palette.errorColor,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        value: value,
        onChanged: onChanged,
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 20,
          color: Palette.light,
        ),
        borderRadius: BorderRadius.circular(8.0),
        elevation: 1,

        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((T item) {
            return Text(
              item.toString(),
              style: getTxt().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            );
          }).toList();
        },
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value.toString(),
            ),
          );
        }).toList(),
      ),
    );
  }
}


class TheInputField extends StatelessWidget {
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final IconData? icon;
  final VoidCallback? onTapIcon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  final bool enabled;
  final int? maxLength;
  final String label;
  final TextInputAction? action;
  final int flex;
  final EdgeInsets? padding;

  final Function(String)? onChange;
  final Function(String)? onSubmit;

  const TheInputField({
    Key? key,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.icon,
    this.onTapIcon,
    this.validator,
    this.enabled = true,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    required this.label,
    this.flex = 0,
    this.onChange,
    this.onSubmit,
    this.action, this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding?? const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        onFieldSubmitted: onSubmit,
        controller: controller,
        keyboardType: minLines == 1 ? keyboardType : TextInputType.multiline,
        textInputAction: minLines == 1 ? action :null,
        cursorColor: Palette.light,
        obscureText: obscureText,
        validator: validator,
        maxLength: maxLength,
        enabled: enabled,
        minLines: obscureText ? 1 : minLines,
        maxLines: obscureText ? 1 : maxLines,
        onChanged: onChange,
        style: getTxt().copyWith(
          fontWeight: FontWeight.normal,
        ),
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
        decoration: InputDecoration(
          filled: true,
          hintText: hint,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 45,
            maxHeight: 20,
          ),
          suffixIcon: icon != null
              ? InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTapIcon,
            child: Icon(
              icon,
              size: 20,
              color: Palette.light,
            ),
          )
              : null,
          hintStyle: getTxt().copyWith(
            color: Palette.light,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          alignLabelWithHint: true,
          labelText: label,
          labelStyle: getTxt().copyWith(
            fontSize: 14,
            color: Palette.light,
            fontWeight: FontWeight.normal,
          ),
          floatingLabelStyle: getTxt().copyWith(
            fontSize: 14,
            color: Palette.light,
            fontWeight: FontWeight.normal,
          ),
          isDense: true,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Palette.light,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Palette.light,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Palette.light,
              width: 1.0,
            ),
          ),
          enabled: enabled,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Palette.errorColor,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Palette.errorColor,
              width: 1.0,
            ),
          ),
          errorMaxLines: 1,
          errorStyle: getTxt().copyWith(
            color: Palette.errorColor,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
        ),
      ),
    );
  }
}


TextStyle getTxt() {
  return const TextStyle();
}
