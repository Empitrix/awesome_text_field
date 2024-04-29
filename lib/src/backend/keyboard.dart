import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

bool checkAlternateKey(List<LogicalKeyboardKey> keys){
	return HardwareKeyboard.instance.logicalKeysPressed
		.where((it) => keys.contains(it)).isNotEmpty;
}


class AlternateKeyboard{
	final LogicalKeyboardKey onKey;
	final bool onShift;
	final bool onCtrl;
	final bool onAlt;
	final bool onTab;
	final bool onMeta;
	final bool ignoreKey;

	AlternateKeyboard({
		required this.onKey,
		this.onAlt = false,
		this.onCtrl = false,
		this.onShift = false,
		this.onTab = false,
		this.onMeta = false,
		this.ignoreKey = false,  // Ignore Logical Key
	});

	@override
	String toString() {
		return "$onKey"
			"${ (onShift || onCtrl || onAlt) ? " -> [${onAlt ? 'ALT' : ''}"
			"${onCtrl ? ', CTRL' : ''}"
			"${onShift ? ', SHIFT' : ''}]":''}";
	}

	bool check(AlternateKeyboard alter){
		bool alterState = alter.onAlt == onAlt &&
			alter.onCtrl == onCtrl &&
			alter.onShift == alter.onShift &&
			alter.onTab == onTab &&
			alter.onMeta == onMeta;
		if(alter.ignoreKey){ return alterState; }
		if(alter.onKey == onKey){ return alterState; }
		return false;
	}
}


AlternateKeyboard checkKeyboardKey(LogicalKeyboardKey key){
	return AlternateKeyboard(
		onKey: key,
		onAlt: checkAlternateKey([LogicalKeyboardKey.alt,
			LogicalKeyboardKey.altLeft, LogicalKeyboardKey.altRight]),
		onCtrl: checkAlternateKey([LogicalKeyboardKey.control,
			LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight]),
		onShift: checkAlternateKey([LogicalKeyboardKey.shift,
			LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight]),
		onMeta: checkAlternateKey([LogicalKeyboardKey.meta,
			LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight]),
		onTab: checkAlternateKey([LogicalKeyboardKey.tab]),
	);
}



typedef KeyboardActivatorAction = KeyEventResult Function(
	FocusNode node, KeyEvent event, TextEditingValue value);

class KeyboardActivator{
	final AlternateKeyboard activator;
	final KeyboardActivatorAction action;

	KeyboardActivator({
		required this.activator,
		required this.action
	});
}


/*
```dart
void testKeyboardActivator(){
	KeyboardActivator activator = KeyboardActivator(
		activator: const SingleActivator(LogicalKeyboardKey.keyB),
		action: (_, __){ return __; }
	); t
}
```
*/