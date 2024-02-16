import 'package:flutter/material.dart';

typedef InlineAction = TextSpan Function(String, Match);

class RegexFormattingStyle {
	final RegExp regex;
	final TextStyle style;
	RegexFormattingStyle({required this.regex, required this.style});
}

class RegexStyle {
	final RegExp regex;
	final TextStyle style;

	RegexStyle({
		required this.regex,
		required this.style,
	});
}

class RegexGroupStyle extends RegexFormattingStyle{
	final RegexStyle regexStyle;

	RegexGroupStyle({
		required super.regex,
		required super.style,
		required this.regexStyle
	});
}

class RegexActionStyle extends RegexFormattingStyle {
	final InlineAction? action;

	RegexActionStyle({
		required super.regex,
		required super.style,
		this.action,
	});
}




TextSpan applyRegexFormattingStyle({
	required String content,
	required List<RegexFormattingStyle> rules,
	required TextStyle? textStyle
}){
	// textStyle = textStyle ?? const TextStyle(fontSize: 14);
	List<TextSpan> spans = [];

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
						spans.add(TextSpan(text: gText, style: fRule.regexStyle.style.copyWith(fontSize: textStyle!.fontSize)));
						return "";
					},
					onNonMatch: (nonMatchedText) {
						spans.add(TextSpan(text: nonMatchedText, style: fRule.style.copyWith(fontSize: textStyle!.fontSize)));
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
						style: fRule.style.copyWith(fontSize: textStyle!.fontSize)
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
}
