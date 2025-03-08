import 'package:daily_amol/service/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/tasbih_provider.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'tasbih_list_screen.dart';
import 'tasbih_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const TasbihScreen(),
    const TasbihListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    final provider = Provider.of<TasbihProvider>(context, listen: false);
    if (index == 0 || index == 2) {
      provider.changeActiveTashbih();
    }
  }

  // Show info dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 10.0,
          backgroundColor: Colors.white,
          title: Text('তথ্য'),
          content: Text(
            'এই অ্যাপটি \n১. আপনাকে প্রতিদিনের আমল এবং তাসবিহ গণনা করতে সাহায্য করবে।\n২. আপনি আমল যোগ করতে পারেন, আমল গণনা করতে পারেন এবং \n৩. আপনার অগ্রগতি ট্র্যাক করতে পারেন।\nএটির অনলাইন ভার্সন ও আরো অনেক আমল সংবলিত ভার্সন খুব শিঘ্রই আসবে ইনশাল্লাহ\n\nআপনার কোন জিজ্ঞাসা থাকলে robiulawal68@gmail.com এই ইমেলে বলতে পারনে।',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('ঠিক আছে'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'প্রতিদিনের আমল'
              : _currentIndex == 1
                  ? provider.activeTasbih
                      ? provider.amol.name
                      : 'অ্যাকটিভ তাসবিহ নেই'
                  : 'আমলের তালিকা',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          SizedBox(width: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Icon(Icons.account_circle),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.info_sharp),
            onPressed: _showInfoDialog, // Show info dialog
          ),
          SizedBox(width: 8),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'আমার আমল',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? 'assets/images/tab_icon_tasbih_active.png'
                  : 'assets/images/tab_icon_tasbih.png',
              height: 25,
            ),
            label: 'আমল গণনা',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'আমলের তালিকা',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}