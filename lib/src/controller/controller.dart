import 'package:awesome_text_field/src/backend/backend.dart';
import 'package:awesome_text_field/src/controller/parse_styles.dart';
import 'package:awesome_text_field/src/models/regex_style.dart';
import 'package:flutter/material.dart';


class AwesomeController extends TextEditingController {
	List<RegexFormattingStyle> regexStyles = [];

	@override
	set value(TextEditingValue newValue) {
		newValue = TextEditingValue(
			text: formatEndLine(newValue.text),
			selection: formatEndLine(newValue.text).length < newValue.selection.start ?
				const TextSelection.collapsed(offset: -1) : newValue.selection,
			composing: newValue.composing
		);
		super.value = newValue;
	}

	@override
	TextSpan buildTextSpan({BuildContext? context, TextStyle? style, required bool withComposing}) {
		final List<TextSpan> textSpanChildren = [];
		TextSpan span = const TextSpan();
		if(regexStyles.isNotEmpty){
			span = _applyRules(
				content: formatEndLine(text),
				textStyle: style ?? const TextStyle(),
				rules: regexStyles
			);
		} else {
			span = TextSpan(text: text, style: style);
		}
		textSpanChildren.add(span);
		return TextSpan(style: style, children: textSpanChildren);
	}

	void setRegexStyle(List<RegexFormattingStyle> styles){
		regexStyles = styles;
	}

	TextSpan _applyRules({
		required String content,
		required TextStyle textStyle,
		required List<RegexFormattingStyle> rules,
	}){
		return ApplyRegexFormattingStyle(
			content: content, rules: rules, textStyle: textStyle).build();
	}
}

