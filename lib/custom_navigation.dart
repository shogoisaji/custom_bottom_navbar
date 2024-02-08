import 'dart:math';

import 'package:custom_bottomnavigation/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavSettings {
  static final Color navBgColor = Colors.blue[200]!;
  static const double navHeight = 100.0;
  static const double upHeight = 15.0;
  static const double iconSize = 40.0;
  static const double iconTopPadding = 8.0;
  static const Color iconColor = Colors.blue;
  static const Color iconBgColor = Color.fromARGB(255, 181, 220, 255);
  static const Color shadowColor = Colors.black;
  static const double shadowSpread = 4.0;
  static const double shadowBlur = 2.0;
  static const double shadowOffset = 2.5;
  static const double shadowOpacity = 0.1;
}

class CustomNavigation extends HookWidget {
  final Function(int) onTap;
  const CustomNavigation({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final currentIndex = useState(0);
    final itemWidth = min(w / NavigationItems.values.length, NavSettings.iconSize * 2.2);

    final animationControllers = List.generate(
      NavigationItems.values.length,
      (index) => useAnimationController(
        duration: const Duration(milliseconds: 300),
      ),
    );
    final animations =
        animationControllers.map((controller) => CurvedAnimation(parent: controller, curve: Curves.easeInOut)).toList();

    useEffect(() {
      for (int i = 0; i < NavigationItems.values.length; i++) {
        if (i == currentIndex.value) {
          animationControllers[i].forward();
        } else {
          animationControllers[i].reverse();
        }
      }
      return;
    }, [currentIndex.value]);

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: CustomPaint(
            painter: NavigationFillPainter(
              color: NavSettings.navBgColor,
              width: w,
              height: NavSettings.navHeight,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...List.generate(
                  NavigationItems.values.length,
                  (index) => GestureDetector(
                    onTap: () {
                      onTap(index);
                      currentIndex.value = index;
                    },
                    child: AnimatedBuilder(
                      animation: animations[index],
                      builder: (context, child) {
                        return SizedBox(
                          height: NavSettings.navHeight + NavSettings.upHeight,
                          width: itemWidth,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: itemWidth / 2,
                                child: CustomPaint(
                                  painter: NavigationItemPainter(
                                    color: NavSettings.navBgColor,
                                    width: itemWidth,
                                    height: NavSettings.navHeight,
                                    upValue: animations[index].value * 15,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: NavSettings.navHeight -
                                    NavSettings.iconSize * 1.2 -
                                    NavSettings.iconTopPadding +
                                    animations[index].value * NavSettings.upHeight,
                                left: itemWidth / 2 - NavSettings.iconSize * 1.2 / 2,
                                child: Container(
                                  width: NavSettings.iconSize * 1.2,
                                  height: NavSettings.iconSize * 1.2,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: NavSettings.iconBgColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: NavSettings.shadowColor.withOpacity(NavSettings.shadowOpacity),
                                        spreadRadius: NavSettings.shadowSpread,
                                        blurRadius: NavSettings.shadowBlur,
                                        offset: const Offset(0, NavSettings.shadowOffset),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    NavigationItems.values[index].icon,
                                    color: NavSettings.iconColor,
                                    size: NavSettings.iconSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NavigationItemPainter extends CustomPainter {
  NavigationItemPainter({required this.color, required this.width, required this.height, required this.upValue});

  final Color color;
  final double width;
  final double height;
  final double upValue;

  @override
  void paint(Canvas canvas, Size size) {
    final double xStrength = upValue * 1.2;

    final Offset p1 = Offset(xStrength, -height);
    final Offset p2 = Offset(width / 2 - xStrength, -height - upValue);
    final Offset p3 = Offset(width / 2, -height - upValue);
    final Offset p4 = Offset(width / 2 + xStrength, -height - upValue);
    final Offset p5 = Offset(width - xStrength, -height);
    final Offset p6 = Offset(width, -height);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    /// 凸形状
    final path = Path();
    path.lineTo(0, -height);
    path.cubicTo(
      p1.dx,
      p1.dy,
      p2.dx,
      p2.dy,
      p3.dx,
      p3.dy,
    );
    path.cubicTo(
      p4.dx,
      p4.dy,
      p5.dx,
      p5.dy,
      p6.dx,
      p6.dy,
    );
    path.lineTo(width, 0);
    path.close();

    canvas.drawPath(path.shift(Offset(-width / 2, 0)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class NavigationFillPainter extends CustomPainter {
  NavigationFillPainter({
    required this.color,
    required this.width,
    required this.height,
  });

  final Color color;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, -height);
    path.lineTo(width, -height);
    path.lineTo(width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
