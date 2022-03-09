import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  //final Color backgroundColor = Colors.green;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;

  const MainAppbar({Key? key, required this.title, required this.appBar, required this.widgets}) 
    : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      automaticallyImplyLeading: false,
      elevation: 0,
      //backgroundColor: backgroundColor,
      actions: widgets,
      // leading: IconButton(
      //   onPressed: () => Scaffold.of(context).openDrawer(), 
      //   icon: const Icon(Icons.abc_outlined),
      //   )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
