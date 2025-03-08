import 'dart:async'; // Import for Timer

import 'package:flutter/material.dart';

import '../service/AppColors.dart';

class HomeScreenSlider extends StatefulWidget {
  const HomeScreenSlider({super.key});

  @override
  State<HomeScreenSlider> createState() => _HomeScreenSliderState();
}

class _HomeScreenSliderState extends State<HomeScreenSlider> {
  static List<String> ayahs = [
    'َ‘তখন তুমি তোমার রবের সপ্রশংস তাসবিহ পাঠ করো এবং তাঁর কাছে ক্ষমা চাও নিশ্চয়ই তিনি তওবা কবুলকারী।’\n(সুরা নসর : আয়াত ৩)',
    '‘আর তুমি আল্লাহর কাছে ক্ষমা চাও; নিশ্চয় আল্লাহ ক্ষমাশীল ও পরম দয়ালু।’ \n(সুরা নিসা : আয়াত ১০৬)',
    '‘আর তুমি ক্ষমা চাও তোমার এবং মুমিন নর-নারীর ত্রুটি-বিচ্যুতির জন্য।’\n(সুরা মুহাম্মদ : আায়ত ১৯)',
    '‘সুতরাং বলেছি, তোমরা তোমাদের প্রতিপালকের কাছে ইসতেগফার তথা ক্ষমা প্রার্থনা কর; নিশ্চয়ই তিনি মহাক্ষমাশীল।\n(সুরা নুহ : আয়াত ১০)',
    '‘আর যে ব্যক্তি মন্দ কাজ করবে কিংবা নিজের প্রতি জুলুম করবে তারপর আল্লাহর কাছে ক্ষমা চাইবে; সে আল্লাহকে পাবে ক্ষমাশীল ও পরম দয়ালু।’\n(সুরা নিসা : আয়াত ১১০)',
    '‘আর আল্লাহ এমন নন যে, তাদেরকে আজাব দেবেন এ অবস্থায় যে, তুমি তাদের মাঝে বিদ্যমান এবং আল্লাহ তাদেরকে আজাব দানকারী নন এমতাবস্থায় যে, তারা ক্ষমা প্রার্থনা করছে।’\n(সুরা আনফাল : আয়াত ৩৩)',
  ];

  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < ayahs.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.border, width: 1),
        image: DecorationImage(
          image: AssetImage('assets/images/dua_hero_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/dev_sign.png', height: 30),
            ),
          ),
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _pageController,
              itemCount: ayahs.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Text(
                      ayahs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
