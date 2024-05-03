import 'package:flutter/material.dart';
import 'package:password_manager/components/BottomNavBar.dart';
import 'package:password_manager/views/HomeScreen.dart';

class NavigationScreen extends StatefulWidget{
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with TickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(controller: tabController),
        body: TabBarView(
          controller: tabController,
          children: [
            HomeScreen(),
            Container(),
            Container(),
          ],
        ),
    );
  }
}