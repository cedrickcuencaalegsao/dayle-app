import 'package:flutter/material.dart';
import '../../feature/home/screen/home.dart';
import 'package:intl/intl.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  // get the date today.
  // final DateTime _today = DateTime.now();
  // separrate the date format for spicific purposes.
  final String _day = DateFormat('EEEE').format(DateTime.now());
  final String _month = DateFormat('MMMM').format(DateTime.now());
  final String _date = DateFormat('d').format(DateTime.now());
  final String _year = DateFormat('y').format(DateTime.now());

  final List<Widget> _pages = <Widget>[
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dayle Planner.',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dayle Planner.',
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _day,
                          style: const TextStyle(
                              fontFamily: 'AntipastoPro',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$_month $_date, $_year',
                          style: const TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 8.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      _date,
                      style: const TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: 35.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text(
                  "Cedrick Alegsao",
                  style: TextStyle(
                    fontFamily: 'Antipasto',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  'cedrickalegsao@email.com',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 16.0,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    'CA',
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.orange,
                  size: 35,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Fredokaone',
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.bar_chart,
                  color: Colors.orange,
                  size: 35,
                ),
                title: const Text(
                  'Statistics',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: Colors.orange,
                  size: 35,
                ),
                title: const Text(
                  'Calendar',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                onTap: () {},
              ),
              const Divider(
                color: Colors.black12,
                thickness: 1.0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 35,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/sign_in');
                },
              ),
            ],
          ),
        ),
        body: _pages[0],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {},
          child: const Icon(Icons.create, color: Colors.white, size: 35.0),
        ),
      ),
    );
  }
}
