import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosSwipePage<T> extends Page<T> {
  const IosSwipePage({
    required this.child,
    this.maintainState = false,
    this.fullscreenDialog = false,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final bool maintainState;
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) => _IosSwipeRoute<T>(this);
}

// ==================== _IosSwipeRoute ==================== //
class _IosSwipeRoute<T> extends PageRoute<T> {
  _IosSwipeRoute(this.page) : super(settings: page);

  final IosSwipePage<T> page;
  bool _canSwipe = false;

  @override
  bool get opaque => true;
  @override
  bool get barrierDismissible => true;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => page.maintainState;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => page.child;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final pages = Navigator.of(context).widget.pages;

    if (pages.length > 1) {
      _canSwipe = true;
    } else {
      _canSwipe = false;
    }

    final previousPage = _findPreviousPage(context);

    // текущая страница
    final currentSlide = AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final width = MediaQuery.of(context).size.width;
        final raduis =
            animation.value == 1 ? 0.0 : MediaQuery.paddingOf(context).top;
        final offsetX = (1.0 - animation.value) * width;
        return Transform.translate(
          offset: Offset(offsetX.clamp(0, width), 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(raduis),

            child: _buildSwipeGesture(context, child),
          ),
        );
      },
    );

    // предыдущая страница — лёгкий параллакс
    final previousAnimated =
        previousPage == null
            ? const SizedBox.shrink()
            : AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final width = MediaQuery.of(context).size.width;
                final progress = animation.value;
                final slideOffset = -width * 0.25 * progress;
                return Transform(
                  transform: Matrix4.identity()..translate(slideOffset),
                  alignment: Alignment.centerLeft,
                  child: IgnorePointer(ignoring: true, child: previousPage),
                );
              },
            );

    return Container(
      color: _canSwipe ? Colors.black : Colors.transparent,
      child: Stack(children: [previousAnimated, currentSlide]),
    );
  }

  /// добавляем свайп-жест на child

  Widget _buildSwipeGesture(BuildContext context, Widget child) {
    if (!_canSwipe) return child;

    final width = MediaQuery.of(context).size.width;
    double dragStartValue = 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) {
        dragStartValue = controller?.value ?? 1.0;
        controller?.stop();
      },
      onHorizontalDragUpdate: (details) {
        if (!_canSwipe || controller?.isAnimating == true) return;

        // свайп вправо уменьшает value (от 1.0 → 0.0)
        final delta = details.primaryDelta ?? 0.0;
        final progressDelta = delta / width;
        final newValue = (controller!.value - progressDelta).clamp(0.0, 1.0);
        controller!.value = newValue;
      },
      onHorizontalDragEnd: (details) {
        if (!_canSwipe) return;

        final velocity = details.velocity.pixelsPerSecond.dx;
        final progress = controller!.value;
        final shouldPop = velocity > 500 || progress < 0.7;

        final target = shouldPop ? 0.0 : 1.0;
        final distance = (progress - target).abs();
        final duration = Duration(
          milliseconds: lerpDouble(250, 600, distance)! ~/ 1,
        );

        if (shouldPop) {
          void listener(AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              controller?.removeStatusListener(listener);
              if (navigator?.canPop() ?? false) navigator?.pop();
            }
          }

          controller?.addStatusListener(listener);
          controller?.animateTo(
            0.0,
            duration: duration,
            curve: Curves.easeOutCubic,
          );
        } else {
          controller?.animateTo(
            1.0,
            duration: duration,
            curve: Curves.easeOutCubic,
          );
        }
      },
      child: child,
    );
  }

  Widget? _findPreviousPage(BuildContext context) {
    final pages = Navigator.of(context).widget.pages;
    bool showBackButton = pages.length > 1;

    final Page<dynamic>? page =
        pages.length > 1 ? pages[pages.length - 2] : null;

    if (page is IosSwipePage) return page.child;
    if (page is CupertinoPage) return page.child;
    if (page is MaterialPage) return page.child;
    return null;
  }
}
