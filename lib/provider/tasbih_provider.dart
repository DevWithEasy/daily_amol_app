import 'package:daily_amol/model/AmolModel.dart';
import 'package:flutter/widgets.dart';

class TasbihProvider with ChangeNotifier {
  bool activeTasbih = false;
  void changeActiveTashbih() {
    activeTasbih = false;
    notifyListeners();
  }

  AmolModel amol = AmolModel.fromJson({
    "id": 3,
    "name": "সুবহানাল্লাহ",
    "arabic": "سُبْحَانَ اللّٰه",
    "bangla": "সুবহানাল্লাহ",
    "description": "",
    "target": 100,
    "count": 0,
    "totalCount": 0,
    "defaultAmol": true,
    "favourite": true,
  });
  void addAmol(AmolModel selectAmol) {
    activeTasbih = true;
    amol = selectAmol;
    notifyListeners();
  }

  List<AmolModel> amols = [];
  void addAmols(List<AmolModel> passAmols) {
    amols = passAmols;
    notifyListeners();
  }

  List<AmolModel> chooseAmols = [];
  void addChooseAmols(List<AmolModel> passAmols) {
    chooseAmols = passAmols;
    notifyListeners();
  }

  String language = 'ar';
  void changeLanguage() {
    language == 'ar' ? language = 'bn' : language = 'ar';
    notifyListeners();
  }
}
