import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {

    final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key,required this.currentIndex , required this.onTap});

  

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: 60,
    //   width: double.infinity,
    //   decoration: const BoxDecoration(color: Colors.white12),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       spacing: 5,
    //       children: [
    //         TextButton.icon(
    //           onPressed: () {},
    //           label: Text('Home'),
    //           icon: Icon(Icons.home),
    //         ),
    //         TextButton.icon(
    //           onPressed: () {},
    //           label: Text('Stats'),
    //           icon: Icon(Icons.stacked_bar_chart),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart),label: 'Stats')
    ]);
  }
}
