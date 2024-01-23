import 'package:awesome_text_field/src/backend/backend.dart';
import 'package:awesome_text_field/src/models/regex_style.dart';
import 'package:flutter/material.dart';

class AwesomeController extends TextEditingController {
	AwesomeController();
	List<RegexGroupStyle> regexStyles = [];

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


	// @override
	// set text(String newText) {
	// 	super.text = newText;
	// }


	@override
	TextSpan buildTextSpan({BuildContext? context, TextStyle? style, required bool withComposing}) {
		final List<TextSpan> textSpanChildren = [];
		TextSpan span = const TextSpan();
		if(regexStyles.isNotEmpty){
			span = _applyRules(
				// content: text,
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

	// void setRegexStyle(List<RegexStyle> styles){
	void setRegexStyle(List<RegexGroupStyle> styles){
		regexStyles = styles;
	}


	TextSpan _applyRules({
		required String content,
		required TextStyle textStyle,
		// required List<RegexStyle> rules,
		required List<RegexGroupStyle> rules,
	}){
		List<InlineSpan> spans = [];
		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
			onMatch: (match) {
				String mText = match.group(0)!;
				// RegexStyle mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));
				RegexGroupStyle mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));

				// if(mRule.action != null){
				// 	spans.add(mRule.action!(mText, match));
				// } else {
				// 	spans.add(
				// 		TextSpan(text: mText, style: mRule.style.copyWith(fontSize: textStyle.fontSize))
				// 	);
				// }

				for(RegexStyle rStyle in mRule.regexStyles){
					mText.splitMapJoin(
						rStyle.regex,
						onMatch: (Match m){
							spans.add(TextSpan(text: m.group(0)!, style: rStyle.style.copyWith(fontSize: textStyle.fontSize)));
							return m.group(0)!;
						},
						onNonMatch: (String non){
							spans.add(TextSpan(text: non, style: mRule.style.copyWith(fontSize: textStyle.fontSize)));
							return non;
						}
					);
				}


				// print(mText);

				return mText;
			},
			onNonMatch: (nonMatchedText) {
				spans.add(
					TextSpan(
						text: nonMatchedText,
						style: textStyle
					)
				);
				return nonMatchedText;
			},
		);

		return TextSpan(children: spans);
	}


}
