import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';


bool isDesktop(){
	if(kIsWeb){ return true; }
	if(Platform.isWindows || Platform.isLinux || Platform.isMacOS){ return true; }
	return false;
}


String formatEndLine(String input){
	/* Flutter text field can't support "\r" char */
	// return input.replaceAll("\u000a", "\u000b");
	// return input.replaceAll("\r", "");

	return input.replaceAll("\r\n", "\n").replaceAll("\n\r", "\n").replaceAll("\r", "\n");
	// return input.replaceAll("\r\n", "\n").replaceAll("\r", "\n");

	// return utf8.decode(utf8.encode(input));

}
