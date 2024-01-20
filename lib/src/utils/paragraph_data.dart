import 'dart:ui' as ui;
import 'package:awesome_text_field/src/models/line_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// void getParagraphData(String text, double width, TextStyle style) {
// 	final builder = ui.ParagraphBuilder(ui.ParagraphStyle());
// 	builder.pushStyle(ui.TextStyle(fontSize: style.fontSize, height: style.height));
// 	builder.addText(text);
// 	final paragraph = builder.build();
// 	paragraph.layout(ui.ParagraphConstraints(width: width));
// 	debugPrint("-- " * 20);
// 	debugPrint("longestLine: ${paragraph.longestLine}");
// 	debugPrint("minIntrinsicWidth: ${paragraph.minIntrinsicWidth}");
// 	debugPrint("maxIntrinsicWidth: ${paragraph.maxIntrinsicWidth}");
// 	debugPrint("minIntrinsicWidth: ${paragraph.didExceedMaxLines}");
// 	debugPrint("Line NUMBER AT: ${paragraph.getLineNumberAt(5)}");
// 	debugPrint("width: ${paragraph.width}");
// 	debugPrint("height: ${paragraph.height}");
// 	debugPrint("Metric Width: ${paragraph.computeLineMetrics().first.width}");
// 	debugPrint("Metric Height: ${paragraph.computeLineMetrics().first.height}");
// 	// debugPrint(style.height.toString());
// }
double calcLongestLine(String text, double width, TextStyle style) {
	final builder = ui.ParagraphBuilder(ui.ParagraphStyle());
	builder.pushStyle(ui.TextStyle(fontSize: style.fontSize, height: style.height, letterSpacing: style.letterSpacing));
	builder.addText(text);
	final paragraph = builder.build();
	paragraph.layout(ui.ParagraphConstraints(width: width));
	return paragraph.longestLine;
}

/* Calculate text size */
Size calcTextSize(
	BuildContext context, String text, [TextStyle? style]){
	return (TextPainter(
		text: TextSpan(text: text, style: style),
		maxLines: null,
		textScaler: MediaQuery.of(context).textScaler,
		textDirection: TextDirection.ltr)..layout()
	).size;
}

int getCurrentNumLine(TextEditingController controller) {
	TextSelection selection = controller.selection;
	String textBeforeCursor = controller.text.substring(0, selection.baseOffset);
	int lineNumber = RegExp(r'\n').allMatches(textBeforeCursor).length + 1;
	return lineNumber;
}



void updateDisplayedLineCount({
	required BuildContext context,
	required TextEditingController controller,
	required TextStyle style,
	required ValueChanged<LineStatus> onUpdate
}) {
	TextPainter textPainter = TextPainter(
		text: TextSpan(text: controller.text, style: style),
		textDirection: TextDirection.ltr,
		maxLines: null,
	);

	// 10000 letter and then line will break
	double theWidth = calcTextSize(context, "_").width * 10000;
	// print("CALC WIDTH: $theWidth");
	textPainter.layout(maxWidth: theWidth);
	List<LineMetrics> metrics = textPainter.computeLineMetrics();
	List<String> line = controller.text.split("\n");
	line.sort((a, b) => a.length.compareTo(b.length));
	onUpdate(
		LineStatus(
			lineNumber: metrics.length,
			lineHeight: metrics.isNotEmpty ? metrics.first.height: calcTextSize(context, "", style).height,
			currentLine: getCurrentNumLine(controller),
			longestLine: calcTextSize(
				context, line.last.isNotEmpty ?  line.last.substring(0, line.last.length - 10) : " ",
				style).width
		)
	);

}
