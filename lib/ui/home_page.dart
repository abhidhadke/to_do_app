import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/models/tasks.dart';
import 'package:to_do_list/services/notification_services.dart';
import 'package:to_do_list/services/theme_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/ui/add_task_bar.dart';
import 'package:to_do_list/ui/themes.dart';
import 'package:to_do_list/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:to_do_list/ui/widgets/task_tile.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DateTime _selectedDate = DateTime.now();
  final _taskcontroller = Get.put(TaskController());
  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskcontroller.getTasks();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 15,),
          _showTasks(),

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
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
  _addTaskBar(){
    return Container(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
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
          MyButton(label: '+ Add Task',
              onTap: () async {
            await Get.to(() => AddTaskPage());
            _taskcontroller.getTasks();
          }
          )
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
        const SizedBox(width: 20,)
      ],
    );
  }
  _showTasks(){
    return Expanded(
        child: Obx( () {
          return ListView.builder(
            itemCount: _taskcontroller.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskcontroller.taskList[index];
              var debug = task.toJson();
              debugPrint('$debug');
              if(task.repeat == 'Daily'){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                debugPrint('Tapped');
                                _showBottomOption(context, task);
                              },
                              child: TaskTile(task),
                            ),
                          ],
                        ),
                      ),
                    )
                );
              }
              if(task.date == DateFormat.yMd().format(_selectedDate)){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                debugPrint('Tapped');
                                _showBottomOption(context, task);
                              },
                              child: TaskTile(task),
                            ),
                          ],
                        ),
                      ),
                    )
                );
              }else{
                return Container();
              }
            },
          );
        }
        )
        );
  }
  _bottomSheetButton({required String label, required Function()? onTap, required Color clr, bool isClose = false, required BuildContext context}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            color: isClose ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]! : clr,
            width: 2
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr
        ),
        child: Center(child: Text(label, style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),)),
      ),

    );
  }
  _showBottomOption(BuildContext context, Task task){
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(

          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height*0.24,
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
              const Spacer(),
              _bottomSheetButton(
                  label: "Task Completed",
                  onTap: (){
                    _taskcontroller.delete(task);
                    _taskcontroller.getTasks();
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context,),
              _bottomSheetButton(
                label: "Close",
                onTap: (){
                  Get.back();
                },
                clr: Colors.white,
                isClose: true,
                context: context,),
              const SizedBox(height: 10,)

            ],
          ),
        ),
      )
    );
  }
}

