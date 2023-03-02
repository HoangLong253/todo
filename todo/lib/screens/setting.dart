import 'package:flutter/material.dart';
import 'package:todo/screens/daylightmode.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Chế độ tối'),
            trailing: Icon(
              Icons.navigate_next,
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DayLight())),
          ),
        ],
      )
    );
  }
}
