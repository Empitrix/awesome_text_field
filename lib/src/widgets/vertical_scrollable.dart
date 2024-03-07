import 'package:flutter/material.dart';

ScrollController ctrl = ScrollController();

class VerticalScrollable extends StatelessWidget {
	final Widget child;
	final double? width;
	const VerticalScrollable({
		super.key,
		required this.child,
		this.width
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				SingleChildScrollView(
					controller: ctrl,
					scrollDirection: Axis.horizontal,
					child: IntrinsicWidth(
						child: child,
					),
				)
			],
		);
	}
}
