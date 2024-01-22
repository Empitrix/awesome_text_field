import 'package:awesome_text_field/src/models/regex_style.dart';
import 'package:flutter/material.dart';

class AwesomeController extends TextEditingController {
	AwesomeController();

	// List<RegexStyle> regexStyles = [];
	List<RegexGroupStyle> regexStyles = [];

	@override
	TextSpan buildTextSpan({BuildContext? context, TextStyle? style, required bool withComposing}) {
		final List<TextSpan> textSpanChildren = [];

		// print(regexStyles);
		// // textSpanChildren.add(TextSpan(text: text, style: style));
		// text.splitMapJoin(
		// 	RegExp(r'\#\w+'),
		// 	onMatch: (Match onMatch){
		// 		textSpanChildren.add(TextSpan(text: onMatch.group(0)!.replaceAll("#", ""), style: const TextStyle(color: Colors.red)));
		// 		return onMatch.group(0)!;
		// 	},
		// 	onNonMatch: (String nonMatchString){
		// 		textSpanChildren.add(TextSpan(text: nonMatchString, style: style));
		// 		return nonMatchString;
		// 	}
		// );
		TextSpan span = const TextSpan();

		if(regexStyles.isNotEmpty){
			span = _applyRules(
				// context: context,
				content: text,
				textStyle: style ?? const TextStyle(),
				rules: regexStyles
			);
		} else {
			span = TextSpan(text: text, style: style);
		}
		textSpanChildren.add(span);

		return TextSpan(style: style, children: textSpanChildren);
		// return TextSpan(
		// 	style: style,
		// 	children: <TextSpan>[
		// 		TextSpan(text: value.composing.textBefore(value.text)),
		// 		TextSpan(
		// 			style: style,
		// 			text: value.composing.textInside(value.text),
		// 		),
		// 		TextSpan(text: value.composing.textAfter(value.text)),
		// 	],
		// );


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
