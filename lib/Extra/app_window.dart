import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bookstore_app/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const borderColor = Color.fromARGB(255, 0, 0, 0);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
        iconNormal: Theme.of(context).textTheme.labelLarge!.color,
        mouseOver: Theme.of(context).buttonTheme.colorScheme!.background,
        mouseDown: Theme.of(context).highlightColor,
        iconMouseOver: Theme.of(context).textTheme.button!.color,
        iconMouseDown: Theme.of(context).textTheme.button!.color);

    final closeButtonColors = WindowButtonColors(
        mouseOver: const Color(0xFFD32F2F),
        mouseDown: const Color(0xFFB71C1C),
        iconNormal: Theme.of(context).textTheme.button!.color,
        iconMouseOver: Colors.white);

    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        if (!context.watch<checkoutNotif>().isAppMaximized)
          MaximizeWindowButton(
            colors: buttonColors,
            onPressed: () {
              context.read<checkoutNotif>().appMaximize();
              appWindow.maximize();
            },
          ),
        if (context.watch<checkoutNotif>().isAppMaximized)
          RestoreWindowButton(
            colors: buttonColors,
            onPressed: () {
              context.read<checkoutNotif>().appRestore();
              appWindow.restore();
            },
          ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

class RestoreWindowButton extends WindowButton {
  RestoreWindowButton(
      {Key? key,
      WindowButtonColors? colors,
      VoidCallback? onPressed,
      bool? animate})
      : super(
            key: key,
            colors: colors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) =>
                RestoreIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.maximizeOrRestore());
}

class _MoveWindowEX extends StatelessWidget {
  const _MoveWindowEX({Key? key, this.child}) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              appWindow.startDragging();
            },
            // onPanUpdate: (detail) {
            //   if (appWindow.size >=
            //       Size(_width - (5 / 100), _height - (5 / 100))) {
            //     //print(appWindow.size);
            //   }
            // },
            onDoubleTap: () {
              appWindow.maximizeOrRestore();
              if (!appWindow.isMaximized) {
                context.read<checkoutNotif>().appMaximize();
              } else {
                context.read<checkoutNotif>().appRestore();
              }
            },
            child: child ?? Container());
  }
}

class MoveWindowEX extends StatelessWidget {
  final Widget? child;
  const MoveWindowEX({Key? key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (child == null) return const _MoveWindowEX();
    return _MoveWindowEX(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: child!)]),
    );
  }
}
