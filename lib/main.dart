import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'provider/tasbih_provider.dart';
import 'service/shared_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedData.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasbihProvider())
      ],
      child: const DailyAmolApp(),
    ),
  );
}