import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/database/db_helper.dart';
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
  final _taskController = Get.put(TaskController());
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
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: MediaQuery.of(context).size.height*0.014,),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMMd().format(DateTime.now()),
                style:subHeadingStyle,),
              Text('Today',
                style: headingStyle,),
            ],
          ),
          MyButton(label: '+ Add Task',
              onTap: () async {
            await Get.to(() => const AddTaskPage());
            _taskController.getTasks(DateFormat('yyyy-MM-dd').format(_selectedDate));

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
          // notifyHelper.displayNotification(
          //   title: 'Theme Changed',
          //     body: Get.isDarkMode ? 'Activated Light Theme' : 'Activated Dark Theme'
          // );
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
    _taskController.getTasks(DateFormat('yyyy-MM-dd').format(_selectedDate));
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: MediaQuery.of(context).size.height*0.614,

        decoration: BoxDecoration(

          color:  context.theme.colorScheme.tertiary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          )
        ),
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Expanded(
                child: Obx( () {
                  return _taskController.taskList.isEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/tasks.png'),
                      Center(child: Text('No available Tasks.', style: hintTitleStyle,))
                    ],
                  )
                      :
                  ListView.builder(
                    itemCount: _taskController.taskList.length,
                    itemBuilder: (_, index) {
                      Task task = _taskController.taskList[index];
                      var debug = task.toJson();
                      debugPrint('$debug');
                      DateTime dateTime = DateFormat.jm().parse(task.startTime.toString());
                      dateTime = dateTime.subtract(Duration(minutes: task.remind!));
                      debugPrint('$dateTime');
                      var myTime = DateFormat('HH:mm').format(dateTime);
                      //debugPrint(myTime);
                     if(task.isCompleted == 0){
                       NotifyHelper().scheduledNotification(
                           int.parse(myTime.toString().split(":")[0]),
                           int.parse(myTime.toString().split(":")[1]),
                           task);
                     }
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

                    },
                  );
                }
                )
                ),
          ],
        ),
      ),
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
          height: task.isCompleted == 1 ? MediaQuery.of(context).size.height*0.19 : MediaQuery.of(context).size.height*0.27,
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Column(
            children: [
              Container(
                height: 9,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
              const Spacer(),

              Visibility(
                visible: (task.isCompleted == 0),
                  child: _bottomSheetButton(
                label: "Task Completed",
                onTap: () async {
                  if(task.repeat == 'None'){
                    _taskController.taskComplete(task);
                  }
                  else if(task.repeat == 'Weekly'){
                    DateTime date = DateTime.parse(task.date!);
                    date = date.add(const Duration(days: 7));
                    String dateString = DateFormat('yyyy-MM-dd').format(date);
                    debugPrint('next date is $dateString');
                    await DBHelper.editDate(task, DateFormat('yyyy-MM-dd').format(date));

                  }else if(task.repeat == 'Daily'){

                    DateTime date = DateTime.parse(task.date!);
                    date = date.add(const Duration(days: 1));
                      String dateString = DateFormat('yyyy-MM-dd').format(date);
                    debugPrint('next date is $dateString');
                    await DBHelper.editDate(task, DateFormat('yyyy-MM-dd').format(date));
                  }
                  else if(task.repeat == 'Monthly '){
                    DateTime date = DateTime.parse(task.date!);
                    date = date.add(const Duration(days: 30));
                    String dateString = DateFormat('yyyy-MM-dd').format(date);
                    debugPrint('next date is $dateString');
                    await DBHelper.editDate(task, DateFormat('yyyy-MM-dd').format(date));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(todayCompleted);
                  _taskController.getTasks(DateFormat('yyyy-MM-dd').format(_selectedDate));
                  Get.back();
                },
                clr: primaryClr,
                context: context,)),
              _bottomSheetButton(
                  label: 'Delete Task',
                  onTap: (){
                    _taskController.delete(task);
                    _taskController.getTasks(DateFormat('yyyy-MM-dd').format(_selectedDate));
                    ScaffoldMessenger.of(context).showSnackBar(taskDeletedBar);
                    Get.back();
                  },
                  clr: pinkClr,
                  context: context
              ),
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

