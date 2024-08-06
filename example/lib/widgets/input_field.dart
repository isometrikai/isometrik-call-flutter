import 'package:call_qwik_example/main.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.controller,
    this.onchange,
    this.validator,
    this.obscureText = false,
    this.obscureCharacter = ' ',
    this.suffixIcon,
    this.prefixIcon,
    TextInputType? textInputType,
    this.readOnly = false,
    this.onTap,
    this.label,
    this.hintText,
    this.borderColor,
    this.fillColor,
    this.hintStyle,
    this.alignLabelWithHint,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.cursorColor,
    this.style,
    this.radius,
    this.onFieldSubmit,
    this.textInputAction,
    this.contentPadding,
    this.focusNode,
    this.textCapitalization,
    this.autofillHints,
    this.filled,
    this.showBorder = true,
    this.autofocus = false,
  })  : _textInputType = textInputType ?? TextInputType.text,
        _isPhone = false,
        onCountryChange = null,
        selectedCountry = null;

  const CustomInputField.userName({
    super.key,
    required this.controller,
    this.onchange,
    this.obscureCharacter = '*',
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.label,
    this.hintText,
    this.borderColor,
    this.fillColor,
    this.hintStyle,
    this.alignLabelWithHint,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.cursorColor,
    this.style,
    this.radius,
    this.onFieldSubmit,
    this.textInputAction,
    this.contentPadding,
    this.focusNode,
    this.textCapitalization = TextCapitalization.words,
    this.autofillHints,
    this.filled,
    this.showBorder = true,
    this.autofocus = false,
  })  : _textInputType = TextInputType.name,
        obscureText = false,
        _isPhone = false,
        onCountryChange = null,
        selectedCountry = null;

  const CustomInputField.email({
    super.key,
    required this.controller,
    this.onchange,
    this.obscureText = false,
    this.obscureCharacter = '*',
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.label,
    this.hintText,
    this.borderColor,
    this.fillColor,
    this.hintStyle,
    this.alignLabelWithHint,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.cursorColor,
    this.style,
    this.radius,
    this.onFieldSubmit,
    this.textInputAction,
    this.contentPadding,
    this.focusNode,
    this.textCapitalization,
    this.autofillHints,
    this.filled,
    this.showBorder = true,
    this.autofocus = false,
  })  : _textInputType = TextInputType.emailAddress,
        _isPhone = false,
        onCountryChange = null,
        selectedCountry = null;

  const CustomInputField.phone({
    super.key,
    required this.controller,
    this.onchange,
    this.obscureText = false,
    this.obscureCharacter = '*',
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.label,
    this.hintText,
    this.borderColor,
    this.fillColor,
    this.hintStyle,
    this.alignLabelWithHint,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.cursorColor,
    this.style,
    this.radius,
    this.onFieldSubmit,
    this.textInputAction,
    this.contentPadding,
    this.focusNode,
    this.onCountryChange,
    this.selectedCountry,
    this.textCapitalization,
    this.autofillHints,
    this.filled,
    this.showBorder = true,
    this.autofocus = false,
  })  : _textInputType = TextInputType.phone,
        _isPhone = true;

  const CustomInputField.password({
    super.key,
    required this.controller,
    this.onchange,
    this.obscureText = true,
    this.obscureCharacter = '*',
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.label,
    this.hintText,
    this.borderColor,
    this.fillColor,
    this.hintStyle,
    this.alignLabelWithHint,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.cursorColor,
    this.style,
    this.radius,
    this.onFieldSubmit,
    this.textInputAction,
    this.contentPadding,
    this.focusNode,
    this.textCapitalization,
    this.autofillHints,
    this.filled,
    this.showBorder = true,
    this.autofocus = false,
  })  : _textInputType = TextInputType.visiblePassword,
        _isPhone = false,
        onCountryChange = null,
        selectedCountry = null;

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType _textInputType;
  final Function(String value)? onchange;
  final bool obscureText;
  final String obscureCharacter;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmit;
  final String? label;
  final String? hintText;
  final Color? borderColor;
  final Color? fillColor;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final bool? alignLabelWithHint;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final double? radius;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;
  final FocusNode? focusNode;
  final bool _isPhone;
  final void Function(Country)? onCountryChange;
  final Country? selectedCountry;
  final TextCapitalization? textCapitalization;
  final Iterable<String>? autofillHints;
  final bool? filled;
  final bool showBorder;
  final bool autofocus;

  InputDecorationTheme _decorationTheme(BuildContext context) =>
      context.theme.inputDecorationTheme;

  InputBorder _border(BuildContext context) => !showBorder
      ? InputBorder.none
      : _decorationTheme(context).border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? Dimens.thirty),
            borderSide: BorderSide(
              color: borderColor ?? CallColors.secondary,
              width: 1,
            ),
          );

  InputBorder _enabledBorder(BuildContext context) => !showBorder
      ? InputBorder.none
      : _decorationTheme(context).enabledBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? Dimens.thirty),
            borderSide: BorderSide(
              color: borderColor ?? CallColors.secondary,
              width: 1,
            ),
          );

  InputBorder _focusedBorder(BuildContext context) => !showBorder
      ? InputBorder.none
      : _decorationTheme(context).focusedBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? Dimens.thirty),
            borderSide: BorderSide(
              color: borderColor ?? CallColors.primary,
              width: 2,
            ),
          );

  InputBorder _errorBorder(BuildContext context) => !showBorder
      ? InputBorder.none
      : _decorationTheme(context).errorBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? Dimens.thirty),
            borderSide: BorderSide(
              color: borderColor ?? CallColors.red,
              width: 1,
            ),
          );

  InputBorder _disabledBorder(BuildContext context) => !showBorder
      ? InputBorder.none
      : _decorationTheme(context).focusedErrorBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? Dimens.thirty),
            borderSide: BorderSide(
              color: borderColor ?? CallColors.grey,
              width: 1,
            ),
          );

  InputBorder _focusedErrorBorder(BuildContext context) => !showBorder
      ? InputBorder.none
      : _decorationTheme(context).focusedErrorBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? Dimens.thirty),
            borderSide: BorderSide(
              color: borderColor ?? CallColors.red,
              width: 1,
            ),
          );

  void _pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: onCountryChange ?? (_) {},
      countryListTheme: CountryListThemeData(
        backgroundColor: CallColors.background,
        borderRadius: BorderRadius.circular(radius ?? Dimens.thirty),
        inputDecoration: InputDecoration(
          filled: _decorationTheme(context).filled,
          alignLabelWithHint: _decorationTheme(context).alignLabelWithHint,
          fillColor: fillColor ??
              _decorationTheme(context).fillColor ??
              CallColors.secondary.withOpacity(0.2),
          hintText: 'Search',
          hintStyle: hintStyle ?? _decorationTheme(context).hintStyle,
          isDense: _decorationTheme(context).isDense,
          contentPadding: contentPadding ??
              _decorationTheme(context).contentPadding ??
              Dimens.edgeInsets16,
          border: _border(context),
          enabledBorder: _enabledBorder(context),
          focusedBorder: _focusedBorder(context),
          errorBorder: _errorBorder(context),
          disabledBorder: _disabledBorder(context),
          focusedErrorBorder: _focusedErrorBorder(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: TextFormField(
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmit,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          minLines: minLines ?? 1,
          autofocus: autofocus,
          style: style,
          onTap: onTap,
          cursorColor: cursorColor,
          readOnly: readOnly,
          controller: controller,
          autofillHints: autofillHints ?? _textInputType.autofillHints,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: _decorationTheme(context).labelStyle,
            filled: filled ?? _decorationTheme(context).filled,
            alignLabelWithHint: _decorationTheme(context).alignLabelWithHint,
            fillColor: fillColor ??
                _decorationTheme(context).fillColor ??
                CallColors.secondary.withOpacity(0.2),
            hintText: hintText ?? (label != null ? 'Enter $label' : null),
            hintStyle: hintStyle ?? _decorationTheme(context).hintStyle,
            isDense: _decorationTheme(context).isDense,
            contentPadding: contentPadding ??
                _decorationTheme(context).contentPadding ??
                Dimens.edgeInsets16,
            border: _border(context),
            enabledBorder: _enabledBorder(context),
            focusedBorder: _focusedBorder(context),
            errorBorder: _errorBorder(context),
            disabledBorder: _disabledBorder(context),
            focusedErrorBorder: _focusedErrorBorder(context),
            counterText: '',
            errorMaxLines: 2,
            suffixIcon: suffixIcon,
            prefixIcon: _isPhone ? _countryPrefix(context) : prefixIcon,
            prefixIconConstraints: _isPhone
                ? BoxConstraints(
                    maxWidth: Dimens.sixty,
                  )
                : null,
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: _textInputType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          obscureText: obscureText,
          obscuringCharacter: obscureCharacter,
          onChanged: onchange,
        ),
      );

  Widget _countryPrefix(BuildContext context) => TapHandler(
        onTap: () => _pickCountry(context),
        child: Padding(
          padding: Dimens.edgeInsets8_0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Spacer(),
              Text(
                '+${selectedCountry?.phoneCode}',
                // 'IN +91',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: CallColors.unselected,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                width: 2,
                child: ColoredBox(
                  color: borderColor ?? CallColors.secondary,
                ),
              ),
            ],
          ),
        ),
      );
}
