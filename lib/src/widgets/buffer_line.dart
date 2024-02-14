import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:awesome_text_field/src/models/line_status.dart';
import 'package:awesome_text_field/src/utils/paragraph_data.dart';
import 'package:flutter/material.dart';


class BufferLine extends StatelessWidget {
	const BufferLine({
		super.key,
		required this.lineStatus,
		required this.linePalette,
		required this.borderRadius,
		required this.border,
		required this.topBufferMargin
	});

	final ValueNotifier<LineStatus> lineStatus;
	final LineNumberPalette linePalette;
	final BorderRadiusGeometry? borderRadius;
	final BoxBorder? border;
	final double topBufferMargin;

	@override
	Widget build(BuildContext context) {
		return ValueListenableBuilder(
			valueListenable: lineStatus,
			builder: (_, value, __){
				// print(value.lineNumber);
				// print(calcTextSize(context, "${value.lineNumber}").width);
				return Container(
					decoration: BoxDecoration(
						color: linePalette.background,
						borderRadius: borderRadius,
						border: border ?? Border(
							right: BorderSide(color: linePalette.indexColor!, width: 1)
						)
					),
					// width: 25,
					width: calcTextSize(context, "${value.lineNumber}").width + 10,

					height: MediaQuery.sizeOf(context).height +
						((value.lineNumber - 8) * value.lineHeight),
					child: Column(
						children: [
							SizedBox(height: topBufferMargin),
							for(int l = 0; l < (value.lineNumber + 1); l++) if(l != value.lineNumber)
								Container(
									color: (l + 1 == value.currentLine) ?
										linePalette.onSelectBackground : linePalette.indexBackground,
									height: value.lineHeight,
									width: 50,
									/*child: Center(
										child: FittedBox(child: Text(
											"${l+1}",
											style: TextStyle(
												color: (l + 1 == value.currentLine) ?
												linePalette.onSelectIndex :
												linePalette.indexColor,
												fontWeight: FontWeight.bold
											)
										))
									),*/
									child: Align(
										alignment: Alignment.centerRight,
										child: FittedBox(child: Text(
											"${l+1}  ",
											style: TextStyle(
												color: (l + 1 == value.currentLine) ?
												linePalette.onSelectIndex :
												linePalette.indexColor,
												fontWeight: FontWeight.bold,
												fontSize: 10
											)
										))
									),
								)
						],
					),
				);
			},
		);
	}
}
