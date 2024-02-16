import 'package:awesome_text_field/src/backend/backend.dart';
import 'package:awesome_text_field/src/controller/parse_styles.dart';
import 'package:awesome_text_field/src/models/regex_style.dart';
import 'package:flutter/material.dart';

class AwesomeController extends TextEditingController {
	AwesomeController();
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
	void setRegexStyle(List<RegexFormattingStyle> styles){
		regexStyles = styles;
	}


	TextSpan _applyRules({
		required String content,
		required TextStyle textStyle,
		// required List<RegexStyle> rules,
		required List<RegexFormattingStyle> rules,
	}){
		/*
		List<InlineSpan> spans = [];
		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
			onMatch: (Match match) {
				String fText = match.group(0)!;
				RegexFormattingStyle fRule = rules.firstWhere((rule) => rule.regex.hasMatch(fText));

				if(fRule is RegexGroupStyle){

					fText.splitMapJoin(
						fRule.regexStyle.regex,
						onMatch: (Match match) {
							String gText = match.group(0)!;
							spans.add(TextSpan(text: gText, style: fRule.regexStyle.style.copyWith(fontSize: textStyle.fontSize)));
							return "";
						},
						onNonMatch: (nonMatchedText) {
							spans.add(TextSpan(text: nonMatchedText, style: fRule.style.copyWith(fontSize: textStyle.fontSize)));
							return "";
						},
					);

				} else if (fRule is RegexActionStyle) {
					if(fRule.action != null){
						TextSpan actionSpan = fRule.action!(fText, match);
						if(actionSpan.toPlainText().length == (match.end - match.start)){
							spans.add(actionSpan);
						} else {
							throw RangeError("Length of output is not as same as length of input\nInput: ${(match.end - match.start)}\nOutput: ${actionSpan.toPlainText().length}");
						}
					} else {
						spans.add(TextSpan(
							text: fText,
							style: fRule.style.copyWith(fontSize: textStyle.fontSize)
						));
					}
				} else {
					spans.add(TextSpan(text: fText, style: fRule.style));
				}
				return "";
			},
			onNonMatch: (nonMatchedText) {
				spans.add(
					TextSpan(
						text: nonMatchedText,
						style: textStyle
					)
				);
				return "";
			},
		);
		return TextSpan(children: spans);
		*/
		return ApplyRegexFormattingStyle(
			content: content, rules: rules, textStyle: textStyle).build();
	}


}
