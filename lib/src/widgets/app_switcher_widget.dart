import 'package:flutter/material.dart';

import '../router/app_router.dart';

class AppSwitcherWidget extends StatelessWidget {
  const AppSwitcherWidget({
    super.key,
    required this.child,
    this.animationType = 'fade',
    this.durationInMiliSec = 500,
    this.direction = AxisDirection.left,
  });

  final Widget child;
  final String? animationType;
  final AxisDirection? direction;
  final int? durationInMiliSec;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: durationInMiliSec!),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
        return animationType == 'scale'
            ? ScaleTransition(scale: animation, child: child)
            : animationType == 'slide'
                ? SlideTransition(
                    position: Tween<Offset>(begin: getBeginOffset(direction!), end: Offset.zero).animate(curvedAnimation),
                    child: child)
                : FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
                    child: child,
                  );
      },
      child: child,
    );
  }
}
