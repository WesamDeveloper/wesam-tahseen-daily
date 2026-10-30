import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:motion_tab_bar/helpers/HalfClipper.dart';
import 'package:motion_tab_bar/helpers/HalfPainter.dart';

typedef TabItemWidgetBuilder = Widget Function(Color color, double size);

const double _iconOff = -3;
const double _iconOn = 0;
const double _textOff = 3;
const double _textOn = 1;
const double _alphaOff = 0;
const double _alphaOn = 1;
const int _animDuration = 300;

class CustomMotionTabBar extends StatefulWidget {
  final Color? tabIconColor;
  final Color? tabIconSelectedColor;
  final Color? tabSelectedColor;
  final Color? tabBarColor;
  final double? tabIconSize;
  final double? tabIconSelectedSize;
  final double? tabBarHeight;
  final double? tabSize;
  final TextStyle? textStyle;
  final ValueChanged<int>? onTabItemSelected;
  final String initialSelectedTab;
  final List<String> labels;
  final List<TabItemWidgetBuilder> tabItemBuilders;
  final bool useSafeArea;
  final MotionTabBarController? controller;

  const CustomMotionTabBar({
    super.key,
    this.textStyle,
    this.tabIconColor = Colors.black,
    this.tabIconSize = 26,
    this.tabIconSelectedColor = Colors.white,
    this.tabIconSelectedSize = 26,
    this.tabSelectedColor = Colors.black,
    this.tabBarColor = Colors.white,
    this.tabBarHeight = 55,
    this.tabSize = 50,
    this.onTabItemSelected,
    required this.initialSelectedTab,
    required this.labels,
    required this.tabItemBuilders,
    this.useSafeArea = true,
    this.controller,
  }) : assert(labels.length == tabItemBuilders.length);

  @override
  State<CustomMotionTabBar> createState() => _CustomMotionTabBarState();
}

class _CustomMotionTabBarState extends State<CustomMotionTabBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween<double> _positionTween;
  late Animation<double> _positionAnimation;

  late AnimationController _fadeOutController;
  late Animation<double> _fadeFabOutAnimation;
  late Animation<double> _fadeFabInAnimation;

  late String selectedTab;
  double fabIconAlpha = 1;

  int get tabAmount => widget.labels.length;
  int get selectedIndex => widget.labels.indexOf(selectedTab);

  double _getPosition(int index) {
    if (tabAmount <= 1) return 0;
    final double pace = 2.0 / (tabAmount - 1);
    return (pace * index) - 1.0;
  }

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialSelectedTab;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: _animDuration),
      vsync: this,
    );

    _fadeOutController = AnimationController(
      duration: const Duration(milliseconds: _animDuration ~/ 5),
      vsync: this,
    );

    final initialPos = _getPosition(selectedIndex);
    _positionTween = Tween<double>(begin: initialPos, end: initialPos);
    _positionAnimation = _positionTween.animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() {
      if (mounted) setState(() {});
    });

    _fadeFabOutAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut),
    )..addListener(() {
      if (mounted) {
        setState(() {
          fabIconAlpha = _fadeFabOutAnimation.value;
        });
      }
    });

    _fadeFabInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 1, curve: Curves.easeOut),
      ),
    )..addListener(() {
      if (mounted) {
        setState(() {
          fabIconAlpha = _fadeFabInAnimation.value;
        });
      }
    });

    if (widget.controller != null) {
      widget.controller!.onTabChange = (index) {
        if (index >= 0 && index < widget.labels.length) {
          _animateToTab(index);
        }
      };
    }
  }

  void _animateToTab(int newIndex) {
    if (widget.labels[newIndex] == selectedTab) return;

    _fadeOutController.reset();
    _fadeOutController.forward();

    final double oldPos = _positionAnimation.value;
    final double newPos = _getPosition(newIndex);

    setState(() {
      selectedTab = widget.labels[newIndex];
    });

    _positionTween.begin = oldPos;
    _positionTween.end = newPos;

    _animationController.reset();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(CustomMotionTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        widget.controller != oldWidget.controller) {
      widget.controller!.onTabChange = (index) {
        if (index >= 0 && index < widget.labels.length) {
          _animateToTab(index);
        }
      };
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.tabBarColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        bottom: widget.useSafeArea,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: widget.tabBarHeight,
              decoration: BoxDecoration(color: widget.tabBarColor),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(tabAmount, (i) {
                  final label = widget.labels[i];
                  final isSelected = label == selectedTab;
                  return _CustomMotionTabItem(
                    title: label,
                    selected: isSelected,
                    builder: widget.tabItemBuilders[i],
                    textStyle:
                        widget.textStyle ??
                        const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                    tabIconColor: widget.tabIconColor ?? Colors.black,
                    tabIconSize: widget.tabIconSize ?? 26,
                    onTap: () {
                      _animateToTab(i);
                      widget.controller?.index = i;
                      widget.onTabItemSelected?.call(i);
                    },
                  );
                }),
              ),
            ),
            IgnorePointer(
              child: Align(
                heightFactor: 0,
                alignment: Alignment(_positionAnimation.value, 0),
                child: FractionallySizedBox(
                  widthFactor: 1.0 / tabAmount,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: widget.tabSize! + 30,
                        width: widget.tabSize! + 30,
                        child: ClipRect(
                          clipper: HalfClipper(),
                          child: Center(
                            child: Container(
                              width: widget.tabSize! + 10,
                              height: widget.tabSize! + 10,
                              decoration: BoxDecoration(
                                color: widget.tabBarColor,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: widget.tabSize! + 15,
                        width: widget.tabSize! + 35,
                        child: CustomPaint(
                          painter: HalfPainter(color: widget.tabBarColor!),
                        ),
                      ),
                      SizedBox(
                        height: widget.tabSize,
                        width: widget.tabSize,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.tabSelectedColor,
                          ),
                          child: Opacity(
                            opacity: fabIconAlpha,
                            child: Center(
                              child: widget.tabItemBuilders[selectedIndex](
                                widget.tabIconSelectedColor ?? Colors.white,
                                widget.tabIconSelectedSize ?? 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomMotionTabItem extends StatelessWidget {
  final String title;
  final bool selected;
  final TabItemWidgetBuilder builder;
  final TextStyle textStyle;
  final Color tabIconColor;
  final double tabIconSize;
  final VoidCallback onTap;

  const _CustomMotionTabItem({
    required this.title,
    required this.selected,
    required this.builder,
    required this.textStyle,
    required this.tabIconColor,
    required this.tabIconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: _animDuration),
              alignment: Alignment(0, selected ? _textOn : _textOff),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child:
                    selected
                        ? Text(
                          title,
                          style: textStyle,
                          softWrap: false,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: _animDuration),
              curve: Curves.easeIn,
              alignment: Alignment(0, selected ? _iconOff : _iconOn),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: _animDuration),
                opacity: selected ? _alphaOff : _alphaOn,
                child: Center(child: builder(tabIconColor, tabIconSize)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
