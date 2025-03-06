import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

class ScreenAppBar extends StatelessWidget {
  const ScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFEDF3F8), width: 2.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'দৈনিক আমল',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'kalpurush',
              // fontFamily: 'mainak',
              // color: AppColors.primary,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: CircleAvatar(
              child: Image.asset('assets/images/user_man.png'),
            ),
          ),
        ],
      ),
    );
  }
}
