import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatefulWidget {
  final int initialIndex;
  final List<Widget> pages;
  final String appBarTitle;

  const BottomNavBarWidget({
    Key? key,
    required this.initialIndex,
    required this.pages,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: widget.pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: SizedBox(), // No icon
          ),
          BottomNavigationBarItem(
            label: 'History',
            icon: SizedBox(),
          ),
          BottomNavigationBarItem(
            label: 'Messages',
            icon: SizedBox(),
          ),
          BottomNavigationBarItem(
            label: 'Reminders',
            icon: SizedBox(),
          ),
        ],
      ),
    );
  }
}
