import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({super.key, this.backgroundColor, required this.child, this.title, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: rednerAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
///---------------------AppBar---------------------///
  AppBar? rednerAppBar(){
    if(title == null){
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(title!,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),),

      );
    }

  }
///-----------------------------------------///
}
