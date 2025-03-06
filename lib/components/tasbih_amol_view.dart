import 'package:daily_amol/provider/tasbih_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasbihAmolView extends StatelessWidget {
  final bool completed;
  const TasbihAmolView({super.key, required this.completed});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(context);
    return GestureDetector(
      onTap: () {
        // Open a modal dialog when tapped
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16), // Add padding
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use minimum height
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'বিস্তারিতঃ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: completed ? Colors.teal : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'নামঃ ${provider.amol.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.amol.arabic,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'me_quran',
                        height: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'বাংলাঃ ${provider.amol.bangla}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'গণনা টার্গেটঃ ${provider.amol.target}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'গণনা করেছেনঃ ${provider.amol.count}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'মোট গণনা করেছেনঃ ${provider.amol.count}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the modal
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: completed ? const Color(0xDFECFAF9) : Colors.white,
        ),
        child: Center(
          child: Text(
            provider.language == 'ar'
                ? provider.amol.arabic
                : provider.amol.bangla,
            textDirection:
                provider.language == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            textAlign:
                provider.language == 'ar' ? TextAlign.justify : TextAlign.left,
            style: TextStyle(
              color: completed ? Colors.teal : Colors.black,
              fontSize: provider.language == 'ar' ? 16 : 14,
              fontFamily: provider.language == 'ar' ? 'me_quran' : 'kalpurush',
              height: provider.language == 'ar' ? 2 : 1.7,
            ),
          ),
        ),
      ),
    );
  }
}
