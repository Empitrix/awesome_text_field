import 'package:awesome_text_field/src/utils/insert_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<String, bool> _logical = {
	"ctrl": false,
	"shift": false,
	"alt": false
};


void _updateLogical(KeyEvent event){
	/* Will update that pressed shift, ctrl, alt */

	// Get 'SHIFT'
	if(event.logicalKey == LogicalKeyboardKey.shiftLeft ||
		event.logicalKey == LogicalKeyboardKey.shiftRight){
		_logical["shift"] = true;
	} else {
		_logical["shift"] = false;
	}

	// Get 'CTRL'
	if(event.logicalKey == LogicalKeyboardKey.controlRight ||
		event.logicalKey == LogicalKeyboardKey.controlLeft){
		_logical["ctrl"] = true;
	} else {
		_logical["ctrl"] = false;
	}

	// Get 'ALT'
	if(event.logicalKey == LogicalKeyboardKey.altRight ||
		event.logicalKey == LogicalKeyboardKey.altLeft){
		_logical["alt"] = true;
	} else {
		_logical["alt"] = false;
	}
}



TextEditingValue? applyKeyboardAction({
	required KeyEvent event,
	required TextEditingController controller,
	required tabSize,
}){
	if(event is KeyDownEvent){ return null; }

	TextEditingValue value = controller.value;

	if(event.logicalKey == LogicalKeyboardKey.tab){
		value = insertData(controller, " " * tabSize);
	}

	if(event.logicalKey == LogicalKeyboardKey.digit9 && _logical["shift"]!){
		value = insertData(controller, ")", 1);
	}

	if(event.logicalKey == LogicalKeyboardKey.quote && _logical["shift"]!){
		value = insertData(controller, '"', 1);
	}

	_updateLogical(event);
	return value;
}
