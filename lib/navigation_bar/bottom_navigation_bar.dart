import 'package:flutter/material.dart';
import 'package:aps_mobile/navigation_bar/accounts_management.dart';

import '../delete_HomePage.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: (index) {
            onItemTapped(index);

            // Handle navigation when "Accounts" is pressed (index 0)
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_rounded),
              label: 'Accounts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_sharp),
              label: 'Spending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.remove_circle_outline_sharp),
              label: 'Incoming',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart),
              label: 'All',
            ),
          ],
        ),
      ),
    );
  }
}
