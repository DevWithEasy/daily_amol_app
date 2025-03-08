import 'dart:convert';

import 'package:daily_amol/model/AmolModel.dart';
import 'package:daily_amol/service/AppColors.dart';
import 'package:daily_amol/service/shared_data.dart';
import 'package:daily_amol/utils/en_bn_number_convert.dart';
import 'package:flutter/material.dart';

import '../service/AmolServe.dart';

class TasbihListScreen extends StatefulWidget {
  const TasbihListScreen({super.key});

  @override
  State<TasbihListScreen> createState() => _TasbihListScreenState();
}

class _TasbihListScreenState extends State<TasbihListScreen> {
  List<AmolModel> amols = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadAmols();
  }

  Future<void> _loadAmols() async {
    setState(() {
      _loading = true;
      amols = Amolserve.getAmols();
      _loading = false;
    });
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  // Save updated Amols to shared preferences
  Future<void> _saveAmols() async {
    final amolsString = json.encode(amols);
    await SharedData.setString('amols', amolsString);
  }

  // Open modal dialog to create a new Amol
  void _openCreateAmolModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController arabicController = TextEditingController();
    final TextEditingController banglaController = TextEditingController();
    final TextEditingController targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আমল এড করুনঃ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'নাম'),
                  expands: false,
                ),
                TextField(
                  controller: arabicController,
                  decoration: InputDecoration(labelText: 'আরবি'),
                  expands: false,
                ),
                TextField(
                  controller: banglaController,
                  decoration: InputDecoration(labelText: 'বাংলা'),
                  expands: false,
                ),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'টার্গেট লিখুন'),
                  expands: false,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'বাতিল',
                        // style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Validate input
                        if (nameController.text.isNotEmpty &&
                            targetController.text.isNotEmpty) {
                          // Create a new Amol
                          final newAmol = AmolModel(
                            id: amols.length + 1,
                            name: nameController.text,
                            arabic:
                                arabicController.text.isEmpty
                                    ? "N/A"
                                    : arabicController.text,
                            bangla:
                                banglaController.text.isEmpty
                                    ? "N/A"
                                    : banglaController.text,
                            description: '',
                            target: int.parse(targetController.text),
                            count: 0,
                            totalCount: 0,
                            defaultAmol: false,
                            favourite: false,
                          );

                          // Add the new Amol to the list
                          setState(() {
                            amols.add(newAmol);
                          });
                          await _saveAmols();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields')),
                          );
                        }
                      },
                      child: Text(
                        'সেইভ করুন',
                        // style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Open modal dialog to edit an existing Amol
  void _openEditAmolModal(AmolModel amol) {
    final TextEditingController nameController = TextEditingController(
      text: amol.name,
    );
    final TextEditingController arabicController = TextEditingController(
      text: amol.arabic,
    );
    final TextEditingController banglaController = TextEditingController(
      text: amol.bangla,
    );
    final TextEditingController targetController = TextEditingController(
      text: amol.target.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আমল এডিট করুনঃ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                if (!amol.defaultAmol)
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'নাম'),
                    expands: false,
                  ),
                if (!amol.defaultAmol)
                  TextField(
                    controller: arabicController,
                    decoration: InputDecoration(labelText: 'আরবি'),
                    expands: false,
                  ),
                if (!amol.defaultAmol)
                  TextField(
                    controller: banglaController,
                    decoration: InputDecoration(labelText: 'বাংলা'),
                    expands: false,
                  ),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'টার্গেট লিখুন'),
                  expands: false,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'বাতিল',
                        // style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Validate input
                        if (nameController.text.isNotEmpty &&
                            targetController.text.isNotEmpty) {
                          // Update the Amol
                          setState(() {
                            amol.name = nameController.text;
                            amol.arabic =
                                arabicController.text.isEmpty
                                    ? "N/A"
                                    : arabicController.text;
                            amol.bangla =
                                banglaController.text.isEmpty
                                    ? "N/A"
                                    : banglaController.text;
                            amol.target = int.parse(targetController.text);
                          });

                          // Save the updated list to shared preferences
                          await _saveAmols();

                          // Close the modal
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields')),
                          );
                        }
                      },
                      child: Text(
                        'এডিট করুন',
                        // style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Delete an Amol
  void _deleteAmol(int index) async {
    setState(() {
      amols.removeAt(index);
    });
    _saveAmols();
    showSnackbar('আমল ডিলিট করা হয়েছে।');
  }

  // Save the updated list of Amol to shared preferences
  Future<void> _saveChooseAmols(AmolModel amol) async {
    int index = amols.indexWhere((checkAmol) => checkAmol.id == amol.id);
    if (index != -1) {
      amols[index].favourite = true;
    } else {
      showSnackbar('আমল আইডি খুঁজে পাওয়া যায় নি।');
    }
    setState(() {});
    _saveAmols();
  }

  // Function to remove an Amol from the list and update shared preferences
  Future<void> _saveRemoveAmols(AmolModel amol) async {
    int index = amols.indexWhere((checkAmol) => checkAmol.id == amol.id);
    if (index != -1) {
      amols[index].favourite = false;
    } else {
      showSnackbar('আমল আইডি খুঁজে পাওয়া যায় নি।');
    }
    setState(() {});
    _saveAmols();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0.5,
        onPressed: _openCreateAmolModal,
        backgroundColor: const Color(0xFFF0FCFA),
        foregroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child:
            _loading
                ? Center(
                  child: Text(
                    'আমল খোঁজা হচ্ছে...',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
                : SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: amols.length,
                        itemBuilder: (context, index) {
                          final amol = amols[index];
                          return Dismissible(
                            key: Key(amol.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: const Color(0xFFFFD3D0),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              _deleteAmol(index);
                            },
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    title: Text(
                                      amol.defaultAmol
                                          ? 'ডিলিটের ব্যর্থ চেষ্টা'
                                          : 'আপনি কি নিশ্চিত?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      amol.defaultAmol
                                          ? 'এই আমলটি অ্যাপের নিজস্ব আমল। নিজের সেট করা আমল গুলোই শুধু ডিলিট করতে পারবেন।'
                                          : 'আপনি কি এই আমল ডিলিট করতে চান?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text(
                                          amol.defaultAmol ? 'বন্ধ করুন' : 'না',
                                        ),
                                      ),
                                      if (!amol.defaultAmol)
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text('হ্যাঁ'),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: Text(
                                  amol.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  'দৈনিক টার্গেট - ${enToBnNumber(amol.target.toString())} বার',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        _openEditAmolModal(amol);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        amol.favourite
                                            ? Icons.remove_circle
                                            : Icons.add_circle,
                                        color:
                                            amol.favourite
                                                ? const Color(0xFFD80214)
                                                : AppColors.primary,
                                      ),
                                      onPressed: () {
                                        if (amol.favourite) {
                                          _saveRemoveAmols(amol);
                                        } else {
                                          _saveChooseAmols(amol);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
      ),
    );
  }
}
