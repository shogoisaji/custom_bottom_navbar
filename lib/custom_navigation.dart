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
    return true;
  }
}

// class NavigationPainter extends CustomPainter {
//   NavigationPainter({required this.itemCount, required this.currentIndex, required this.navSize, required this.yRange});
//   final int itemCount;
//   final int currentIndex;
//   final Size navSize;
//   final double xRange = 40;
//   final double yRange;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double paddingX = navSize.height / 2;

//     final double upPosition = (navSize.width - paddingX * 2) / itemCount * (currentIndex + 0.5) + paddingX;

//     final Offset p1 = Offset(upPosition - xRange, size.height);
//     final Offset p2 = Offset(upPosition - xRange, size.height - yRange);
//     final Offset p3 = Offset(upPosition, size.height - yRange);
//     final Offset p4 = Offset(upPosition + xRange, -yRange);
//     final Offset p5 = Offset(upPosition + xRange, 0);
//     final Offset p6 = Offset(upPosition + xRange * 2, 0);

//     final paint = Paint()
//       ..color = Colors.red.shade300
//       ..style = PaintingStyle.fill;

//     /// 凸形状
//     final path = Path();
//     path.lineTo(size.height / 2 + xRange, 0);
//     path.cubicTo(
//       p1.dx,
//       p1.dy,
//       p2.dx,
//       p2.dy,
//       p3.dx,
//       p3.dy,
//     );
//     path.cubicTo(
//       p4.dx,
//       p4.dy,
//       p5.dx,
//       p5.dy,
//       p6.dx,
//       p6.dy,
//     );
//     path.lineTo(size.width, 0);
//     path.close();

//     /// R長方形
//     final path2 = Path();
//     // final radius = Radius.circular(navSize.height / 2);
//     final rect = Rect.fromLTWH(0, 0, navSize.width, navSize.height);
//     // final rrect = RRect.fromRectAndRadius(rect2, radius);
//     path2.addRect(rect);

//     final path = Path.combine(
//       PathOperation.union,
//       path,
//       path2,
//     );

//     canvas.drawPath(path.shift(Offset(-navSize.width / 2, 0)), paint);

//     final iconPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(0.5) // 影の色と透明度
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

//     final iconSize = navSize.height * 0.8;

//     final iconPath = Path();
//     final radius = Radius.circular(iconSize);
//     final iconRect = Rect.fromLTWH(0, 0, iconSize, iconSize);
//     final rIconRect = RRect.fromRectAndRadius(iconRect, radius);
//     iconPath.addRRect(rIconRect);
//     canvas.drawPath(
//         iconPath.shift(Offset(-navSize.width / 2 + upPosition - iconSize / 2, navSize.height * 0.1 - yRange + 5)),
//         shadowPaint);
//     canvas.drawPath(
//         iconPath.shift(Offset(-navSize.width / 2 + upPosition - iconSize / 2, navSize.height * 0.1 - yRange)),
//         iconPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
