import 'package:flutter/material.dart';

class LineNumberPalette {
	final Color? indexColor;
	final Color? indexBackground;
	final Color? background;
	final Color? onSelectIndex;
	final Color? onSelectBackground;

	final Color? rightBorderColor;

	LineNumberPalette({
		this.indexColor,
		this.indexBackground,
		this.background,
		this.rightBorderColor,
		this.onSelectIndex,
		this.onSelectBackground
	});

	LineNumberPalette getNull(BuildContext context){
		/* Getting values if there is anything null */
		ColorScheme scheme = Theme.of(context).colorScheme;
		return LineNumberPalette(
			indexColor: indexColor ?? scheme.inverseSurface,
			indexBackground: indexBackground ?? scheme.secondaryContainer,
			onSelectBackground: scheme.inverseSurface,
			onSelectIndex: scheme.surface,
			background: background ?? scheme.background,
			rightBorderColor: rightBorderColor ?? scheme.tertiaryContainer,
		);
	}

}