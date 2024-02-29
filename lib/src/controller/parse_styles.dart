import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:flutter/cupertino.dart';


/* Apply Regex Style to textSpan */
class ApplyRegexFormattingStyle {
	final String content;
	final List<RegexFormattingStyle> rules;
	final TextStyle? textStyle;

	const ApplyRegexFormattingStyle({
		required this.content,
		required this.rules,
		required this.textStyle
	});

	TextSpan build(){
		List<TextSpan> spans = [];  // All the spans



		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
			onMatch: (Match match) {
				String fText = match.group(0)!;

				RegexFormattingStyle? fRule;
				try{
					fRule = rules.firstWhere((rule) => rule.regex.hasMatch(fText));
				} catch(_){}

				if(fRule == null){
					spans.add(TextSpan(text: fText, style: textStyle));
					return "";
				}

				if(fRule is RegexGroupStyle){

					fText.splitMapJoin(
						fRule.regexStyle.regex,
						onMatch: (Match match) {
							String gText = match.group(0)!;
							// idk (should add this to work)
							if(fRule is RegexGroupStyle){
								spans.add(TextSpan(
									text: gText, style: fRule.regexStyle.style
									.copyWith(fontSize: textStyle!.fontSize)));
							} else {
								// If just in case failed (should never happen (need to fix))
								spans.add(TextSpan(text: gText, style: textStyle));
							}
							return "";
						},
						onNonMatch: (nonMatchedText) {
							spans.add(TextSpan(
								text: nonMatchedText, style: fRule!.style.copyWith(fontSize: textStyle!.fontSize)));
							return "";
						},
					);

				} else if (fRule is RegexActionStyle) {
					if(fRule.action != null){
						TextSpan actionSpan = fRule.action!(fText, match);

						if(actionSpan.toPlainText().length == (match.end - match.start)){
							spans.add(actionSpan);
						} else {
							debugPrint("Length of output is not as same as length of input\nInput"
								": ${(match.end - match.start)}\nOutput: ${actionSpan.toPlainText().length}");
							spans.add(TextSpan(text: fText, style: textStyle));
							// throw RangeError(
							// 	"Length of output is not as same as length of input\nInput"
							// 		": ${(match.end - match.start)}\nOutput: ${actionSpan.toPlainText().length}");
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


		/*} catch(e){
			debugPrint("Error: $e");
			spans.add(TextSpan(text: content, style: textStyle));
		}*/

		return TextSpan(children: spans);
	}  // {@End-Build}
}