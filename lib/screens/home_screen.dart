import 'dart:convert';

import 'package:daily_amol/model/AmolModel.dart';
import 'package:daily_amol/service/AmolServe.dart';
import 'package:daily_amol/utils/en_bn_number_convert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/home_screen_slider.dart';
import '../provider/tasbih_provider.dart';
import '../service/AppColors.dart';
import '../service/shared_data.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AmolModel> amols = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndResetCounts();
    _loadAmols();
  }

  Future<void> _loadAmols() async {
    setState(() {
      isLoading = true;
    });

    bool check = Amolserve.checkInitData();
    if (!check) {
      await Amolserve.setAmols();
    }

    setState(() {
      amols = Amolserve.getFavouriteAmols();
      isLoading = false;
    });
  }

  Future<void> _checkAndResetCounts() async {
    final savedDate = SharedData.getString('date');
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (savedDate != currentDate) {
      // Reset counts for all amols
      final amols = Amolserve.getAmols();
      for (var amol in amols) {
        amol.count = 0;
      }

      // Save the updated amols
      final amolString = json.encode(amols);
      SharedData.setString('amols', amolString);
      SharedData.setString('date', currentDate);
    }
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeScreenSlider(),
                const SizedBox(height: 16),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : amols.isEmpty
                    ? Center(
                      child: Text(
                        'আপনি কোন আমল যোগ করেন নি।\nআমলের তালিকা ট্যাবে গিয়ে আমার আমল ট্যাবের আমল যোগ করেন। এবং আমল করা শুরু করুন। ',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                    : ListView.builder(
                      itemCount: amols.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, int index) {
                        final amol = amols[index];
                        return GestureDetector(
                          onTap: () {
                            provider.addAmol(amols[index]);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const MainScreen(
                                      initialIndex: 1,
                                    ), // Open Tasbih tab
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.border,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                amol.count == amol.target
                                    ? Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                    : Icon(
                                      Icons.pending,
                                      color: const Color(0xFFE7E7E7),
                                    ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    amol.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  enToBnNumber('${amol.count}/${amol.target}'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
