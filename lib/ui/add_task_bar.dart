import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/ui/themes.dart';
import 'package:to_do_list/ui/widgets/button.dart';
import 'package:to_do_list/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/tasks.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key,}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat("hh:mm a").format(DateTime.now().add(const Duration(minutes: 30))).toString();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [ 5, 10, 15, 20 ];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 2;
  List<String> toolTip = ['Top priority', 'Medium Priority', 'Low Priority'];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Task',
              style: headingStyle,),
              MyInputField(title: 'Title:', hint: 'Enter your title here',controller: _titleController,),
              MyInputField(title: 'Note:', hint: 'Enter note here', controller: _noteController,),
              MyInputField(title: 'Date:', hint: DateFormat('yyyy-MM-dd').format(_selectedDate),
              widget: IconButton(
                  onPressed: (){
                    _getDateFromUser();
                  },
                  icon: const Icon(Icons.calendar_month_outlined), color: Colors.grey, ),),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(title: 'Start Time:', hint: _startTime,widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(Icons.access_time_rounded,color: Colors.grey,),
                      ) ),),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(title: 'End Time:', hint: _endTime,widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: const Icon(Icons.access_time_rounded,color: Colors.grey,),
                    ) ),)
                ],
              ),
              MyInputField(title: 'Remind:', hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down_outlined,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 8,
                  dropdownColor: dropDownClr,
                  borderRadius: BorderRadius.circular(15),
                  underline: Container(height: 0,),
                  style: subTitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem(
                      value: value.toString(),
                      child: Text(value.toString(), style: GoogleFonts.poppins(),),);
                  }
                  ).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              MyInputField(title: 'Repeat:', hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down_outlined,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 8,
                  dropdownColor: dropDownClr,
                  borderRadius: BorderRadius.circular(15),
                  underline: Container(height: 0,),
                  style: subTitleStyle,
                  items: repeatList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value, style: GoogleFonts.poppins())
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colourPallete(),
                    MyButton(label: "Create Task", onTap: () => _validateData()),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon( Icons.arrow_back_ios_new,
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

  _getDateFromUser() async {
    DateTime? pickerDate =  await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2122));

    if (pickerDate != null){
      setState(() {
        _selectedDate = pickerDate;
      });
    }else{
      debugPrint('Null value passed or something is wrong');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    try{
      var pickedTime = await _showTimePicker();
      if(pickedTime != null){
        String formattedTime = pickedTime.format(context);
        if(pickedTime == null){
          debugPrint('No time');
        }else if(isStartTime == true){
          setState(() {
            _startTime = formattedTime;
          });
        }
        else if (isStartTime == false){
          setState(() {
            _endTime = formattedTime;
          });
      }
      }
    }catch(e){
      debugPrint('$e');
    }
  }

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dialOnly,
        context: context,
        orientation: Orientation.portrait,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(':')[0]),
            minute: int.parse(_startTime.split(':')[1].split(' ')[0])
        )
    );
  }

  _colourPallete () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Task Priority:', style: titleStyle,),
        const SizedBox(height: 8,),
        Wrap(
          children: List<Widget>.generate(3, (int index){
            return Tooltip(
              textStyle: GoogleFonts.poppins(
                color: Colors.white
              ),

              message: toolTip[index],
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: index == 0 ? pinkClr : index == 1 ? yellowClr : primaryClr,
                    child: _selectedColor == index ? const Icon(Icons.done, color: Colors.white,size: 15) : Container(),
                  ),
                ),
              ),
            );
          }),
        ),

      ],
    );
  }

  _validateData(){
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      _addTasktoDB();
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(taskAddedBar);
    }else if (_titleController.text.isEmpty || _noteController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(snackBarRequired);
    }
  }

  _addTasktoDB() async {
   int value = await _taskController.addTask(
        task: Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat('yyyy-MM-dd').format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0
        )
    );
   debugPrint('My id is $value');
  }
}



