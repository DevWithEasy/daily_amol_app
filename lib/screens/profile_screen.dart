import 'dart:convert';

import 'package:daily_amol/service/AmolServe.dart';
import 'package:daily_amol/service/AppColors.dart';
import 'package:daily_amol/service/shared_data.dart';
import 'package:daily_amol/utils/en_bn_number_convert.dart';
import 'package:flutter/material.dart';

import '../model/AmolModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<AmolModel> amols = [];
  int? day = SharedData.getInt('day');

  @override
  void initState() {
    super.initState();
    _loadAmols();
  }

  // Load existing Amols from shared preferences
  Future<void> _loadAmols() async {
    final amolString = SharedData.getString('amols');
    if (amolString != null) {
      try {
        final amolsJson = json.decode(amolString) as List;
        setState(() {
          amols =
              amolsJson
                  .map((amolJson) => AmolModel.fromJson(amolJson))
                  .toList();
        });
      } catch (e) {
        showSnackbar('Error loading Amols: $e');
      }
    }
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  // Show a confirmation dialog before resetting data
  Future<void> _showResetConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('রিসেট নিশ্চিত করুন',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
          content: Text('আপনি কি নিশ্চিত যে আপনি সমস্ত ডেটা রিসেট করতে চান?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('না'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _resetData(); // Reset the data
              },
              child: Text('হ্যাঁ'),
            ),
          ],
        );
      },
    );
  }

  // Reset all data
  void _resetData() {
    Amolserve.resetAmols();
    setState(() {
      amols = Amolserve.getAmols();
      day = 1;
    });
    showSnackbar('সমস্ত ডেটা রিসেট করা হয়েছে।');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ড্যাসবোর্ড'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.restart_alt),
            onPressed: _showResetConfirmationDialog, // Show confirmation dialog
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: amols.length,
              itemBuilder: (context, index) {
                final amol = amols[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(amol.name, style: TextStyle(fontSize: 16)),
                    trailing: SizedBox(
                      width: 80,
                      child: Text(
                        '${enToBnNumber(amol.count.toString())}/${enToBnNumber(day.toString())} দিন',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
