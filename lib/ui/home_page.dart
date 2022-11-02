import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/services/notification_services.dart';
import 'package:to_do_list/services/theme_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/ui/add_task_bar.dart';
import 'package:to_do_list/ui/themes.dart';
import 'package:to_do_list/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DateTime _selectedDate = DateTime.now();
  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar()

        ],
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top:20,left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle:  GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        dayTextStyle:  GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        monthTextStyle:  GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        onDateChange: (date){
          _selectedDate = date;
        },
      ),
    );
  }
  _addTaskBar(){
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style:subHeadingStyle,),
                Text('Today',
                  style: headingStyle,),
              ],
            ),
          ),
          MyButton(label: '+ Add Task', onTap: ()=>Get.to(() => AddTaskPage()))
        ],
      ),
    );
  }
  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: (){
          debugPrint('tapped');
          ThemeService().changeTheme();
          notifyHelper.displayNotification(
            title: 'Theme Changed',
              body: Get.isDarkMode ? 'Activated Light Theme' : 'Activated Dark Theme'
          );
        },
        child: Icon( Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
        size: 20,
        color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(backgroundColor: Colors.transparent,child: Image.asset('assets/profile.png',width: 30,)),
        SizedBox(width: 20,)
      ],
    );
  }
}
