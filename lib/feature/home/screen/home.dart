import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _dates = _generateDates();
  }

  List<DateTime> _generateDates() {
    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return List.generate(
        daysInMonth, (index) => DateTime(now.year, now.month, index + 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.orange.withValues(red: 255, green: 165, blue: 0, alpha: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _dates.map((date) {
                  return InkWell(
                      onTap: () {
                        debugPrint('Selected date: $date');
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: date.day == DateTime.now().day
                              ? Colors.orange.withValues(red: 255, green: 165, blue: 0, alpha: 77)
                              : Colors.white,
                          border: Border.all(
                            color: date.day == DateTime.now().day
                                ? Colors.orange
                                : Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontFamily: 'FredokaOne',
                                fontSize: 20.0,
                                color: date.day == DateTime.now().day
                                    ? Colors.orange
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM').format(date),
                              style: TextStyle(
                                fontFamily: 'AntipastoPro',
                                fontSize: 20.0,
                                color: date.day == DateTime.now().day
                                    ? Colors.orange
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Schedule',
                        style: TextStyle(
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SingleChildScrollView(
                  child: Column(
                    children: [
                      
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
