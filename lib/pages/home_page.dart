import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vordil/pages/settings.dart';
import 'package:vordil/utils/quick_box.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/stats_box.dart';
import '../constants/words.dart';
import '../providers/controller.dart';
import 'package:vordil/pages/user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _word;

  @override
  void initState() {
    final r = Random().nextInt(words.length);
    _word = words[r];

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false)
          .setCorrectWord(word: _word);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vordıl'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<Controller>(
            builder: (_, notifier, __) {
              if (notifier.notEnoughLetters) {
                runQuickBox(context: context, message: 'Yeterli Harf Yok');
              }
              if (notifier.gameCompleted) {
                if (notifier.gameWon) {
                  if (notifier.currentRow == 6) {
                    runQuickBox(context: context, message: 'Vay!');
                  } else {
                    runQuickBox(context: context, message: 'Muhteşem!');
                  }
                } else {
                  runQuickBox(context: context, message: notifier.correctWord);
                }
                Future.delayed(
                  const Duration(milliseconds: 4000),
                  () {
                    if (mounted) {
                      showDialog(
                          context: context, builder: (_) => const StatsBox());
                    }
                  },
                );
              }
              return IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context, builder: (_) => const StatsBox());
                  },
                  icon: const Icon(Icons.bar_chart_outlined));
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
              icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const UserProfile()));
              },
              icon: const Icon(Icons.person))  // User Icon
        ],
      ),
      body: Column(
        children: [
          const Divider(
            height: 1,
            thickness: 2,
          ),
          const Expanded(flex: 7, child: Grid()),
          Expanded(
            flex: 4,
            child: Column(
              children: const [
                KeyboardRow(
                  min: 1,
                  max: 12,
                ),
                KeyboardRow(
                  min: 13,
                  max: 23,
                ),
                KeyboardRow(
                  min: 24,
                  max: 34,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
