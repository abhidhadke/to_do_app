import 'package:flutter/material.dart';
import 'package:to_do_list/services/theme_data.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Text('Theme Dsta',
          style: TextStyle(
            fontSize: 30,
          ),)
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          debugPrint('tapped');
          ThemeService().changeTheme();
        },
        child: const Icon(Icons.nightlight_round),
      ),
      actions: [
        Icon(Icons.person),
        SizedBox(width: 20,)
      ],

    );
  }
}
