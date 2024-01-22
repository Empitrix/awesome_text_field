import 'package:flutter/material.dart';

typedef InlineAction = TextSpan Function(String, Match);

class RegexStyle {
	final RegExp regex;
	final TextStyle style;
	// final InlineAction? action;

	RegexStyle({
		required this.regex,
		required this.style,
		// this.action
	});
}

class RegexGroupStyle {
	final RegExp regex;
	final TextStyle style;
	final List<RegexStyle> regexStyles;
	// final InlineAction? action;

	RegexGroupStyle({
		required this.regex,
		required this.style,
		this.regexStyles = const []
	});
}