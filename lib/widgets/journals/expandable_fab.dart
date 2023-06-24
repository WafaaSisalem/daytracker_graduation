import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/fab_widget.dart';

@immutable
// class Testme extends StatelessWidget {
//   const Testme({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expandable Fab'),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         itemCount: 25,
//         itemBuilder: (context, index) {
//           return FakeItem(isBig: index.isOdd);
//         },
//       ),
//       floatingActionButton: ExpandableFab(
//         children: [
//           ActionButton(
//             onPressed: () {
//               print('gallary pressed!');
//             },
//             icon: svgGallery,
//           ),
//           ActionButton(
//             onPressed: () {
//               print('map pressed!');
//             },
//             icon: svgMap,
//           ),
//           ActionButton(
//             onPressed: () {
//               print('weather pressed!');
//             },
//             icon: svgWeather,
//           ),
//           ActionButton(
//             onPressed: () {
//               print('smile pressed!');
//             },
//             icon: svgSmile,
//           ),
//         ],
//       ),
//     );
//   }
// }

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return FabWidget(
      onPressed: _toggle,
      icon: Icons.close_rounded,
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    for (var i = 0, angleInDegrees = 12.0; i < 4; i++, angleInDegrees += 54) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: Container(
            width: 62.w,
            height: 62.h,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: _toggle,
              child: Icon(
                Icons.add_rounded,
                size: 30.r,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * 80,
        );
        return Positioned(
          right: 164.w + offset.dx.w,
          bottom: 2.0.h + offset.dy.h,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0x28000000), //TODO: COLOR
                offset: Offset(0, 1.5.h),
                blurRadius: 3),
          ],
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.white,
          child: icon,
        ),
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
