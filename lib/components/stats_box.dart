import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vordil/providers/controller.dart';
import 'package:vordil/components/stats_chart.dart';
import 'package:vordil/utils/calculate_stats.dart';
import 'package:vordil/components/stats_tile.dart';
import 'package:vordil/pages/home_page.dart';

class StatsBox extends StatelessWidget {
  const StatsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(size.width * 0.08, size.height * 0.12,
          size.width * 0.08, size.height * 0.12),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(Icons.clear)),
          const Expanded(
              child: Text(
            'İSTATİSTİKLER',
            textAlign: TextAlign.center,
          )),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: getStats(),
              builder: (context, snapshot) {
                List<String> results = ['0', '0', '0', '0', '0'];
                if (snapshot.hasData) {
                  results = snapshot.data as List<String>;
                }
                return Row(
                  children: [
                    StatsTile(
                      heading: 'Oynandı',
                      value: int.parse(results[0]),
                    ),
                    StatsTile(heading: 'Kazanma %\n\'si', value: int.parse(results[2])),
                    StatsTile(
                        heading: 'Güncel\nSeri',
                        value: int.parse(results[3])),
                    StatsTile(
                        heading: 'Maks.\nSeri', value: int.parse(results[4])),
                  ],
                );
              },
            ),
          ),
          const Expanded(
            flex: 8,
            child: StatsChart(),
          ),
          Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    final controller = Provider.of<Controller>(context, listen: false);
                    controller.resetGame();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Tekrar Oyna',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  )))
        ],
      ),
    );
  }
}
