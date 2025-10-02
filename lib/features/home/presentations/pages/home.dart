import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fooddelivery/features/home/presentations/widgets/enhanced_bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Modular.to.pushNamed('/home/');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(opacity: _fadeAnimation, child: RouterOutlet()),
      bottomNavigationBar: EnhancedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Add subtle animation when changing tabs
    _animationController.reset();
    _animationController.forward();

    switch (index) {
      case 0:
        Modular.to.navigate('/home/');
        break;
      case 1:
        Modular.to.navigate('/home/orders');
        break;
      case 2:
        Modular.to.navigate('/home/account');
        break;
    }
  }
}
