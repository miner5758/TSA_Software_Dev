import 'package:flutter/material.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(const Alarmpage());

class Alarmpage extends StatelessWidget {
  const Alarmpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}
var alarms = [{"hour": 15, "minute": 10, "repeat": [1,2,3,4,5,6,7], "name": "testalarm0", "enabled": false},{"hour": 3, "minute": 15, "repeat": [1,2,3,4,5,6,7], "name": "testalarm0"}];

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      
      body: <Widget>[
        /// Home page
        

        /// Alarms page
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              for (var item in alarms ) Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.alarm),
                        title: Text(item["name"] as String),
                        subtitle: Text('${item["hour"]}:${item["minute"]}'),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SwitchExample(),
                      ],
                    ),
                  ],
                )
              ),

            ],
          ),
        ),
      ][currentPageIndex],
    );
  }
}
class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light0 = true;
  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.alarm_on);
      }
      return const Icon(Icons.alarm_off);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
          thumbIcon: thumbIcon,
          value: light1,
          onChanged: (bool value) {
            setState(() {
              light1 = value;
            });
          },
        ),
      ],
    );
  }
}
