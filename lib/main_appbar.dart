import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  //final Color backgroundColor = Colors.green;
  final Widget title;
  final AppBar appBar;
  final List<Widget> widgets;
  final Widget flexSpace;

  const MainAppbar(
      {Key? key,
      required this.title,
      required this.appBar,
      required this.widgets, required this.flexSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: flexSpace,
      title: title,
      automaticallyImplyLeading: false,
      elevation: 0,
      //backgroundColor: backgroundColor,
      actions: widgets,
      // leading: IconButton(
      //   onPressed: () => Scaffold.of(context).openDrawer(),
      //   icon: const Icon(Icons.abc_outlined),
      //   )
      // leading: Text('Book',
      //       style: Theme.of(context).textTheme.headline5),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
