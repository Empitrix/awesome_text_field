import 'package:awesome_text_field/src/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:awesome_text_field/src/models/line_status.dart';
import 'package:awesome_text_field/src/utils/keyboard.dart';
import 'package:awesome_text_field/src/utils/paragraph_data.dart';
import 'package:awesome_text_field/src/widgets/vertical_scrollable.dart';


class AwesomeTextField extends StatefulWidget {
	final TextEditingController controller;
	final TextStyle style;
	final FocusNode? focusNode;
	final InputDecoration decoration;
	final ValueChanged<String>? onChanged;
	final int tabSize;
	const AwesomeTextField({
		super.key,
		required this.controller,
		required this.style,
		this.focusNode,
		this.decoration = const InputDecoration(border: InputBorder.none, hintText: ""),
		this.onChanged,
		this.tabSize = 4,

});

	@override
	State<AwesomeTextField> createState() => _AwesomeTextFieldState();
}

class _AwesomeTextFieldState extends State<AwesomeTextField> {


	ValueNotifier<LineStatus> lineStatus = ValueNotifier(
		LineStatus(lineNumber: 0, lineHeight: 0, currentLine: 0));

	FocusNode keyboardFocus = FocusNode();
	double topBufferMargin = 11.5;
	double filedCursorMargin = 0;
	// line
	// double lineHeight = 0;
	ValueNotifier<double> lineHeight = ValueNotifier(0);

	void _update(){
		updateDisplayedLineCount(
			context: context,
			controller: widget.controller,
			style: widget.style,
			onUpdate: (LineStatus status){
				lineStatus.value = status;
			}
		);
	}


	void initListener(){
		widget.controller.addListener(() {
			_update();
		});
	}

	@override
	void initState() {
		// Update Focus
		if(widget.focusNode != null){
			keyboardFocus = widget.focusNode!;}

		// Update Margin (STOP FROM RE CALCULATING)
		if(isDesktop()){
			topBufferMargin = 10;
			filedCursorMargin = 2;}

		initListener();

		WidgetsBinding.instance.addPostFrameCallback((_){
			if(widget.controller.text.isNotEmpty){
				if(widget.controller.text.isNotEmpty){
					widget.controller.text = formatEndLine(widget.controller.text);
				}
			}
			_update();
			lineHeight.value = calcLineHeight(" ", widget.style);
		});

		super.initState();
	}

	@override
	Widget build(BuildContext context) {
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
									// return AnimatedContainer(
									return Container(
										decoration: BoxDecoration(
											color: Theme.of(context).colorScheme.secondaryContainer,
											borderRadius: BorderRadius.circular(5),
											border: const Border(right: BorderSide(color: Colors.amber, width: 1))
										),
										// width: value.lineNumber > 0 ? 25 : 0,
										// duration: const Duration(seconds: 1),
										width: 25,
										height: MediaQuery.of(context).size.height +
											((value.lineNumber - 10) * value.lineHeight),
										child: Column(
											children: [
												SizedBox(height: topBufferMargin),
												for(int l = 0; l < (value.lineNumber + 1); l++) if(l != value.lineNumber)
													Container(
														color: (l + 1 == value.currentLine) ?
															Colors.amber :
															Theme.of(context).colorScheme.secondaryContainer,
														height: value.lineHeight,
														child: Center(
															child: FittedBox(child: Text(
																"${l+1}",
																style: TextStyle(
																	color: (l + 1 == value.currentLine) ? Colors.black : Colors.amber,
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
									valueListenable: lineHeight,
									builder: (_, lHeight, __){
										return VerticalScrollable(
											child: IntrinsicHeight(
												child: Container(
													margin: EdgeInsets.only(
														top: filedCursorMargin,
														left: 5
													),
													child: KeyboardListener(
														focusNode: FocusNode(),
														autofocus: true,
														onKeyEvent: (KeyEvent event) async {
															TextEditingValue? ctrlValue = applyKeyboardAction(
																event: event, controller: widget.controller, tabSize: 4);
															if(ctrlValue != null){ widget.controller.value = ctrlValue; }
															keyboardFocus.requestFocus();
														},
														child: TextField(
															controller: widget.controller,
															focusNode: keyboardFocus,
															expands: true,
															keyboardType: TextInputType.multiline,
															cursorHeight: lHeight,
															style: widget.style,
															decoration: widget.decoration.copyWith(border: InputBorder.none),
															autofocus: true,
															maxLines: null,
															onChanged: widget.onChanged,
														)
													)
												),
											),
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
