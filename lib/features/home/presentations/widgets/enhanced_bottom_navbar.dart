// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class EnhancedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const EnhancedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.02)
                : Colors.white.withOpacity(0.7),
            blurRadius: 5,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.6),
          selectedFontSize: 12,
          unselectedFontSize: 11,
          iconSize: 24,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                context,
                Icons.home_outlined,
                0,
                currentIndex,
              ),
              activeIcon: _buildNavIcon(
                context,
                Icons.home,
                0,
                currentIndex,
                isActive: true,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                context,
                Icons.library_books_sharp,
                1,
                currentIndex,
              ),
              activeIcon: _buildNavIcon(
                context,
                Icons.library_books_sharp,
                1,
                currentIndex,
                isActive: true,
              ),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                context,
                Icons.person_outline,
                2,
                currentIndex,
              ),
              activeIcon: _buildNavIcon(
                context,
                Icons.person,
                2,
                currentIndex,
                isActive: true,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(
    BuildContext context,
    IconData icon,
    int index,
    int currentIndex, {
    bool isActive = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Icon(
        icon,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: isActive ? 26 : 24,
      ),
    );
  }
}
