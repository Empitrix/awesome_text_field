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