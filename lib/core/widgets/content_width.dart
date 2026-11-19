import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';

/// Centers content and caps its width on wide screens (tablets, landscape),
/// so lines stay readable. Has no effect on phones in portrait.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = AppSizes.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
