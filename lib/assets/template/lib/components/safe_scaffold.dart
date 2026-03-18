import 'package:flutter/material.dart';

/// A custom Scaffold that handles bottom navigation gesture issues
/// by adding safe area and bottom padding
class SafeScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final Widget? drawer;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final Key? scaffoldKey;
  final bool extendBody;
  final EdgeInsets safePadding;

  const SafeScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.drawer,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.scaffoldKey,
    this.extendBody = false,
    this.safePadding = const EdgeInsets.only(bottom: 16.0), // Default bottom padding
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar is PreferredSizeWidget ? appBar as PreferredSizeWidget : null,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: safePadding,
          child: body,
        ),
      ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar != null
          ? Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: bottomNavigationBar,
            )
          : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
    );
  }
}