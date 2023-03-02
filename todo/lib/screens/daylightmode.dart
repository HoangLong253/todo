import 'package:flutter/material.dart';
import 'package:todo/main.dart';

/*class DayLight extends StatelessWidget {
  ThemeMode mode = ThemeMode.light;
  DayLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
           primarySwatch: Colors.blue,
           brightness: Brightness.light
        ),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: mode,
        home: Home(mode: mode,),
    );
  }
}*/
class DayLight extends StatefulWidget {
  DayLight({Key? key}) : super(key: key);
  ThemeMode? mode;

  @override
  State<DayLight> createState() => _DayLightState();
}

class _DayLightState extends State<DayLight> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: widget.mode,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chế độ tối'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('Sáng'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: widget.mode,
                onChanged: (ThemeMode? value) {
                  setState(() {
                    widget.mode = ThemeMode.light;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Tối'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: widget.mode,
                onChanged: (ThemeMode? value) {
                  setState(() {
                    widget.mode = ThemeMode.dark;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Hệ thống'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: widget.mode,
                onChanged: (ThemeMode? value) {
                  setState(() {
                    widget.mode = ThemeMode.system;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
