import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:daily_amol/model/AmolModel.dart';
import 'package:daily_amol/service/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../components/counter_area.dart';
import '../components/counter_control.dart';
import '../components/tasbih_amol_view.dart';
import '../provider/tasbih_provider.dart';
import '../service/AmolServe.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  List<AmolModel> amols = [];
  List<AmolModel> favourites = [];
  int _targetCounter = 0;
  int _counter = 0;
  bool _completed = false;
  String _mode = "volume_off";
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeCounterValues();
    _preloadSound();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initializeCounterValues() {
    final provider = Provider.of<TasbihProvider>(context, listen: false);
    setState(() {
      _counter = provider.amol.count;
      _targetCounter = provider.amol.target;
      _completed = provider.amol.count == provider.amol.target ? true : false;
      amols = Amolserve.getAmols();
      favourites = Amolserve.getFavouriteAmols();
      _mode = Amolserve.getMode();
    });
  }

  Future<void> _preloadSound() async {
    await _audioPlayer.setSource(AssetSource('audio/tasbih_click_sound.mp3'));
    await _audioPlayer.setSource(AssetSource('audio/tasbih_count.mp3'));
  }

  // Save updated Amols to shared preferences
  Future<void> _saveAmols() async {
    final amolsString = json.encode(amols);
    await SharedData.setString('amols', amolsString);
  }

  void _incrementCounter() async {
    if (_counter == _targetCounter) return;

    setState(() {
      _counter++;
    });

    final provider = Provider.of<TasbihProvider>(context, listen: false);

    int id = provider.amol.id;

    int index = amols.indexWhere((amol) => amol.id == id);
    if (index != -1) {
      amols[index].count = _counter;
      amols[index].totalCount = amols[index].totalCount + 1;
      _saveAmols();
    } else {
      showSnackbar('আমল খুঁজে পাওয়া যায়নি।');
    }

    if (_counter == _targetCounter) {
      setState(() {
        _completed = true;
      });
      if (_mode == 'volume_up') {
        await _audioPlayer.play(AssetSource('audio/tasbih_count.mp3'));
      }
      if (_mode == 'vibration') {
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 500);
        }
      }

      showSnackbar('টার্গেট পুরন হয়েছে! পরের আমল লোডিং হচ্ছে...');

      await Future.delayed(const Duration(seconds: 2));

      if (index < favourites.length - 1) {
        final nextAmol = favourites[index + 1];
        provider.addAmol(nextAmol);
        setState(() {
          _counter = nextAmol.count;
          _targetCounter = nextAmol.target;
          _completed = false;
        });
      } else {
        showSnackbar('আর কোন আমল নেই।');
      }
    }

    if (_mode == 'volume_up') {
      await _audioPlayer.play(AssetSource('audio/tasbih_click_sound.mp3'));
    } else if (_mode == 'vibration') {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 100);
      }
    }
  }

  void _decreaseCounter() async {
    if (_counter == 0) return;

    setState(() {
      _counter--;
    });

    final provider = Provider.of<TasbihProvider>(context, listen: false);

    int index = amols.indexWhere((amol) => amol.id == provider.amol.id);
    if (index != -1) {
      amols[index].count = _counter;
      amols[index].totalCount = amols[index].totalCount - 1;
      _saveAmols();
    } else {
      showSnackbar('আমলের আইডি খুঁজে পাওয়া যায়নি।');
    }

    if (_completed) {
      setState(() {
        _completed = false;
      });
    }
  }

  void _resetCounter() async {
    setState(() {
      _counter = 0;
      _completed = false;
    });

    final provider = Provider.of<TasbihProvider>(context, listen: false);

    int index = amols.indexWhere((amol) => amol.id == provider.amol.id);
    if (index != -1) {
      amols[index].count = _counter;

      // Save updated data to shared preferences
      final amolsString = json.encode(amols);
      await SharedData.setString('amols', amolsString);

      // Update provider and notify listeners
      provider.addAmols(amols);
    } else {
      showSnackbar('User with id not found.');
    }
  }

  void _modeChange(String mode) {
    setState(() {
      _mode = mode;
    });
    SharedData.setString('mode', mode);
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
        child:
            !provider.activeTasbih
                ? Center(
                  child: Text(
                    'আমার আমল ট্যাব এ গিয়ে একটি তাসবিহ সিলেক্ট করুন',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                )
                : Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TasbihAmolView(completed: _completed),
                      CounterArea(
                        incrementCounter: _incrementCounter,
                        counter: _counter,
                        targetCounter: _targetCounter,
                        completed: _completed,
                      ),
                      CounterControl(
                        modeChange: _modeChange,
                        mode: _mode,
                        decreaseCounter: _decreaseCounter,
                        resetCounter: _resetCounter,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
