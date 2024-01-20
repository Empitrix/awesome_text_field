import 'package:flutter/material.dart';


TextEditingValue insertData(TextEditingController controller, String data, [int back = 0]){
	/* Input data (String) to text-filed controller */
	TextEditingValue value = controller.value;
	int start = value.selection.start;
	int end = value.selection.end;
	String newText = value.text.replaceRange(start, end, data);
	return value.copyWith(
		text: newText,
		selection: TextSelection.collapsed(offset: start + (data.length - back)),
	);
}

