import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//Copyright (c) 2025 exeshka

/// Создаёт iOS-style transition с параллаксом и свайпом назад
CustomTransitionPage<T> buildIosSwipeTransition<T>({
  required Widget child,
  required GoRouterState state,
  bool maintainState = true,
  bool fullscreenDialog = false,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    name: state.name,
    child: child,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _IosSwipeTransition(
        routeAnimation: animation as ProxyAnimation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}

// ==================== _IosSwipeTransition ==================== //

class _IosSwipeTransition extends StatefulWidget {
  const _IosSwipeTransition({
    required this.routeAnimation,
    required this.secondaryAnimation,
    required this.child,
  });

  final ProxyAnimation routeAnimation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  State<_IosSwipeTransition> createState() => _IosSwipeTransitionState();
}

class _IosSwipeTransitionState extends State<_IosSwipeTransition> {
  AnimationController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool get _canSwipe {
    final router = GoRouter.of(context);
    return router.canPop();
  }

  // Получаем реальный AnimationController из route
  AnimationController? get _routeController {
    final Animation<double>? parent = widget.routeAnimation.parent;
    if (parent is AnimationController) {
      return parent;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([
            widget.routeAnimation,
            widget.secondaryAnimation,
          ]),
          builder: (context, _) {
            // Радиус скругления при открытии
            final radius =
                widget.routeAnimation.value == 1.0 ? 0.0 : topPadding;

            // Основное движение при открытии
            final offsetX = (1.0 - widget.routeAnimation.value) * width;

            // Компенсация при закрытии следующей страницы
            final compensation = 0.25 * width * widget.secondaryAnimation.value;

            final finalOffset = offsetX - compensation;

            return Transform.translate(
              offset: Offset(finalOffset.clamp(-width, width), 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: _buildSwipeGesture(context, widget.child, width),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSwipeGesture(BuildContext context, Widget child, double width) {
    if (!_canSwipe) return child;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        final controller = _routeController;
        if (controller != null) {
          controller.stop();
        }
      },
      onHorizontalDragUpdate: (details) {
        if (!_canSwipe) return;

        final controller = _routeController;
        if (controller == null || controller.isAnimating) return;

        final delta = details.primaryDelta ?? 0.0;
        final progressDelta = delta / width;

        // Свайп вправо уменьшает прогресс (1.0 → 0.0)
        final newValue = (controller.value - progressDelta).clamp(0.0, 1.0);
        controller.value = newValue;
      },
      onHorizontalDragEnd: (details) {
        if (!_canSwipe) return;

        final controller = _routeController;
        if (controller == null) return;

        final velocity = details.velocity.pixelsPerSecond.dx;
        final progress = controller.value;

        // Решаем, закрывать ли страницу
        final shouldPop = velocity > 500 || progress < 0.7;

        final target = shouldPop ? 0.0 : 1.0;
        final distance = (progress - target).abs();
        final duration = Duration(
          milliseconds: lerpDouble(250, 600, distance)!.round(),
        );

        if (shouldPop) {
          void listener(AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              controller.removeStatusListener(listener);
              if (context.mounted && _canSwipe) {
                GoRouter.of(context).pop();
              }
            }
          }

          controller.addStatusListener(listener);
          controller.animateTo(
            0.0,
            duration: duration,
            curve: Curves.easeOutCubic,
          );
        } else {
          controller.animateTo(
            1.0,
            duration: duration,
            curve: Curves.easeOutCubic,
          );
        }
      },
      child: child,
    );
  }
}

// ==================== Пример использования ==================== //

/*
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildIosSwipeTransition(
        child: HomePage(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/details',
      pageBuilder: (context, state) => buildIosSwipeTransition(
        child: DetailsPage(),
        state: state,
      ),
    ),
  ],
);
*/
