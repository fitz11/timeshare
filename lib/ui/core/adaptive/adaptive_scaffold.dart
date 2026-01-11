import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_utils.dart';
import 'adaptive_app_bar.dart';

/// Platform-adaptive scaffold that renders as CupertinoPageScaffold on iOS/macOS
/// and Material Scaffold on other platforms.
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final AdaptiveAppBar? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoPageScaffold(
        navigationBar: appBar != null
            ? CupertinoNavigationBar(
                middle: appBar!.titleWidget ??
                    (appBar!.title != null ? Text(appBar!.title!) : null),
                trailing: appBar!.actions != null && appBar!.actions!.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: appBar!.actions!,
                      )
                    : null,
                leading: appBar!.leading,
                automaticallyImplyLeading: appBar!.automaticallyImplyLeading,
                backgroundColor: appBar!.backgroundColor,
              )
            : null,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        child: SafeArea(
          child: Stack(
            children: [
              body,
              if (floatingActionButton != null)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: floatingActionButton!,
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// Platform-adaptive tab scaffold for bottom navigation.
class AdaptiveTabScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<AdaptiveTabItem> tabs;
  final List<Widget> pages;
  final Color? backgroundColor;

  const AdaptiveTabScaffold({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.tabs,
    required this.pages,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: currentIndex,
          onTap: onIndexChanged,
          items: tabs
              .map((tab) => BottomNavigationBarItem(
                    icon: tab.icon,
                    activeIcon: tab.activeIcon,
                    label: tab.label,
                  ))
              .toList(),
          backgroundColor: backgroundColor,
        ),
        tabBuilder: (context, index) => CupertinoTabView(
          builder: (context) => pages[index],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onIndexChanged,
        backgroundColor: backgroundColor,
        destinations: tabs
            .map((tab) => NavigationDestination(
                  icon: tab.icon,
                  selectedIcon: tab.activeIcon,
                  label: tab.label,
                ))
            .toList(),
      ),
    );
  }
}

/// Represents a tab item for AdaptiveTabScaffold.
class AdaptiveTabItem {
  final Widget icon;
  final Widget? activeIcon;
  final String label;

  const AdaptiveTabItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Platform-adaptive switch.
class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeColor,
      );
    }

    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: activeColor,
    );
  }
}

/// Platform-adaptive checkbox.
class AdaptiveCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;

  const AdaptiveCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoCheckbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        checkColor: activeColor != null ? CupertinoColors.white : null,
      );
    }

    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}

/// Platform-adaptive loading indicator.
class AdaptiveLoadingIndicator extends StatelessWidget {
  final double? radius;
  final Color? color;

  const AdaptiveLoadingIndicator({
    super.key,
    this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoActivityIndicator(
        radius: radius ?? 10.0,
        color: color,
      );
    }

    return SizedBox(
      width: radius != null ? radius! * 2 : 20,
      height: radius != null ? radius! * 2 : 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
