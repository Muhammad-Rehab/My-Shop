import 'package:flutter/material.dart';

class BudgeWidget extends StatelessWidget {
  final Widget child;

  final int cartItemCounts;

  BudgeWidget({
    required this.child,
    required this.cartItemCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 4,
          left: 4,
          child: Container(
            height: 15,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.yellow, borderRadius: BorderRadius.circular(8)),
            child: Text(
              '$cartItemCounts',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
