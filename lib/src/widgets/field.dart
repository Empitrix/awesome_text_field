import 'package:awesome_text_field/src/widgets/vertical_scrollable.dart';
import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:awesome_text_field/src/backend/backend.dart';
import 'package:awesome_text_field/src/widgets/buffer_line.dart';
import 'package:awesome_text_field/src/utils/keyboard.dart';
import 'package:awesome_text_field/src/utils/paragraph_data.dart';
import 'package:flutter/material.dart';


class AwesomeTextField extends StatefulWidget {
	final AwesomeController controller;
	final TextStyle style;
	final FocusNode? focusNode;
	final InputDecoration decoration;
	final ValueChanged<String>? onChanged;
	final int tabSize;
	final BorderRadiusGeometry? borderRadius;
	final List<RegexFormattingStyle> regexStyle;
	final BoxBorder? border;
	final LineNumberPalette? lineNumberColor;
	final ValueChanged<LineStatus>? lineChanged;
	final double widgetHeight;
	final bool wrapMode;

	const AwesomeTextField({
		super.key,
		required this.controller,
		required this.style,
		this.focusNode,
		this.decoration = const InputDecoration(border: InputBorder.none, hintText: ""),
		this.onChanged,
		this.tabSize = 4,
		this.borderRadius,
		this.lineNumberColor,
		this.lineChanged,
		this.border,
		this.widgetHeight = 200,
		this.wrapMode = false,
		this.regexStyle = const [],
});

	@override
	State<AwesomeTextField> createState() => _AwesomeTextFieldState();
}

class _AwesomeTextFieldState extends State<AwesomeTextField> {


	ValueNotifier<LineStatus> lineStatus = ValueNotifier(
		LineStatus(lineNumber: 0, lineHeight: 0, currentLine: 0, currentCol: 0));

	late LineNumberPalette linePalette;
	FocusNode keyboardFocus = FocusNode();
	double topBufferMargin = 11.5;
	double filedCursorMargin = 0;
	ValueNotifier<double> lineHeight = ValueNotifier(0);


	ScrollController bufferCtrl = ScrollController();
	ScrollController editorCtrl = ScrollController();


	void _updateValues(){
		linePalette = widget.lineNumberColor ?? LineNumberPalette().getNull(context);
		widget.controller.setRegexStyle(widget.regexStyle);
	}

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
		_updateValues();
		// Update Focus
		if(widget.focusNode != null){
			keyboardFocus = widget.focusNode!;}

		// Update Margin (STOP FROM RE CALCULATING)
		if(isDesktop()){
			topBufferMargin = 10;
			filedCursorMargin = 2;}

		// initListener();

		WidgetsBinding.instance.addPostFrameCallback((_){
			initListener();
			if(widget.controller.text.isNotEmpty){
				if(widget.controller.text.isNotEmpty){
					widget.controller.text = formatEndLine(widget.controller.text);
				}
			}
			_update();
			lineHeight.value = calcLineHeight(" ", widget.style);
		});

		// Attach buffer-line scroll-controller in with editor
		editorCtrl.addListener(() { bufferCtrl.jumpTo(editorCtrl.offset); });

		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Builder(
			builder: (BuildContext context){

				if(widget.wrapMode){
					return ScrollConfiguration(
						// behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
						behavior: HideScrollbarBehavior(),
						child: Container(
							height: widget.widgetHeight + 2,
							padding: const EdgeInsets.all(5),
							child: TextField(
								controller: widget.controller,
								focusNode: keyboardFocus,
								// expands: true,
								// scrollController: editorCtrl,
								keyboardType: TextInputType.multiline,
								// cursorHeight: lHeight,
								style: widget.style,
								decoration: widget.decoration.copyWith(border: InputBorder.none),
								autofocus: true,
								maxLines: null,
								onChanged: widget.onChanged,
							)
						),
					);
				}
				Widget theWidget = Row(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [

						SizedBox(height: widget.widgetHeight, child: ScrollConfiguration(
						// FittedBox(fit: BoxFit.fitHeight, child: ScrollConfiguration(
							behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
							child: SingleChildScrollView(
								physics: const ClampingScrollPhysics(
									parent: NeverScrollableScrollPhysics()),
								controller: bufferCtrl,
								child: BufferLine(
									lineStatus: lineStatus,
									linePalette: linePalette,
									lineChanged: widget.lineChanged != null ? widget.lineChanged! : (_){},
									borderRadius: widget.borderRadius,
									border: widget.border,
									// topBufferMargin: topBufferMargin - 1.5
									// topBufferMargin: topBufferMargin - 3.5
									topBufferMargin: topBufferMargin - 4.2
								)
							),
						)),
						Expanded(
							child: ValueListenableBuilder(
								valueListenable: lineHeight,
								builder: (_, lHeight, __){
									return VerticalScrollable(
										child: IntrinsicHeight(
											child: Container(
												height: widget.widgetHeight,
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
													child: ScrollConfiguration(
														behavior: HideScrollbarBehavior(),
														child: TextField(
															controller: widget.controller,
															focusNode: keyboardFocus,
															expands: true,
															scrollController: editorCtrl,
															keyboardType: TextInputType.multiline,
															cursorHeight: lHeight,
															style: widget.style,
															decoration: widget.decoration.copyWith(border: InputBorder.none),
															autofocus: true,
															maxLines: null,
															onChanged: widget.onChanged,
														)
													)
												)
											),
										),
									);
								},
							),
						)
					],
				);
				return theWidget;
			},
		);
	}
}


/* Behavior for hiding scroll-bar for Text-Field */
class HideScrollbarBehavior extends MaterialScrollBehavior {
	@override
	Widget buildScrollbar(
		BuildContext context,
		Widget child,
		ScrollableDetails details) => child;
}

