import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';


bool isDesktop(){
	if(kIsWeb){ return true; }
	if(Platform.isWindows || Platform.isLinux || Platform.isMacOS){ return true; }
	return false;
}
