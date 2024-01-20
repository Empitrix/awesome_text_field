import 'package:awesome_text_field/src/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:awesome_text_field/src/models/line_status.dart';
import 'package:awesome_text_field/src/utils/keyboard.dart';
import 'package:awesome_text_field/src/utils/paragraph_data.dart';
import 'package:awesome_text_field/src/widgets/vertical_scrollable.dart';


// TextStyle style = const TextStyle(fontSize: 16, height: 2, fontFamily: "RobotoMono");

ValueNotifier<LineStatus> lineStatus = ValueNotifier(
	LineStatus(lineNumber: 0, lineHeight: 0, currentLine: 0, longestLine: 1)
);


class AwesomeTextField extends StatelessWidget {
	final TextEditingController controller;
	final TextStyle style;
	final FocusNode? focusNode;
	const AwesomeTextField({
		super.key,
		required this.controller,
		required this.style,
		this.focusNode
	});


	@override
	Widget build(BuildContext context) {

		FocusNode keyboardFocus = focusNode ?? FocusNode();

		controller.text;
		controller.addListener(() {
			updateDisplayedLineCount(
				context: context,
				controller: controller,
				style: style,
				onUpdate: (LineStatus status){
					lineStatus.value = status;
				}
			);
		});

		return Builder(
			builder: (BuildContext context){
				Widget theWidget = IntrinsicHeight(
					child: Row(
						mainAxisAlignment: MainAxisAlignment.start,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							ValueListenableBuilder(
								valueListenable: lineStatus,
								builder: (_, value, __){
									return Container(
										// margin: EdgeInsets.only(top: isDesktop() ? 10 : 11.5),
										decoration: BoxDecoration(
											color: Theme.of(context).colorScheme.secondaryContainer,
											border: const Border(right: BorderSide(color: Colors.amber, width: 1))
										),
										width: 25,
										height: MediaQuery.of(context).size.height + ((value.lineNumber - 10) * value.lineHeight),
										child: Column(
											children: [
												SizedBox(height: isDesktop() ? 10 : 11.5),
												for(int l = 0; l < (value.lineNumber); l++) Container(
													color: (l + 1 == value.currentLine) ? Colors.amber : Theme.of(context).colorScheme.secondaryContainer,
													height: value.lineHeight,
													child: Center(
														child: FittedBox(child: Text(
															"${l+1} ",
															style: TextStyle(
																color: (l + 1 == value.currentLine) ? Colors.black : Colors.amber,
																fontFamily: "RobotoMono",
																fontWeight: FontWeight.bold
															)
														))
													),
												)
											],
										),
									);
								},
							),
							Expanded(
								child: ValueListenableBuilder(
									valueListenable: lineStatus,
									builder: (_, value, __){
										return VerticalScrollable(
											width: MediaQuery.of(context).size.width + value.longestLine,
											child: IntrinsicHeight(
												child: Container(
													margin: EdgeInsets.only(
														top: isDesktop() ?  2 : 0,
														left: 5
													),
													child: KeyboardListener(
														focusNode: FocusNode(),
														autofocus: true,
														onKeyEvent: (KeyEvent event) async {
															TextEditingValue? ctrlValue = applyKeyboardAction(
																event: event, controller: controller, tabSize: 4);
															if(ctrlValue != null){ controller.value = ctrlValue; }
															keyboardFocus.requestFocus();
														},
														child: TextField(
															controller: controller,
															focusNode: keyboardFocus,
															expands: true,
															keyboardType: TextInputType.multiline,
															cursorHeight: value.lineHeight,
															style: style,
															decoration: const InputDecoration(border: InputBorder.none, hintText: "Write..."),
															autofocus: true,
															maxLines: null,
														)
													)
												),
											)
										);
									},
								),
							)
						],
					),
				);
				return theWidget;
			},
		);
	}
}
