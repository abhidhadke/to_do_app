import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/ui/themes.dart';
import 'package:to_do_list/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key,}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = '09:30 PM';
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
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
              MyInputField(title: 'Title', hint: 'Enter your title here'),
              MyInputField(title: 'Note', hint: 'Enter note here'),
              MyInputField(title: 'Date', hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                  onPressed: (){
                    _getDateFromUser();
                  },
                  icon: const Icon(Icons.calendar_month_outlined), color: Colors.grey, ),),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(title: 'Start Time', hint: _startTime,widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(Icons.access_time_rounded,color: Colors.grey,),
                      ) ),),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(title: 'End Time', hint: _endTime,widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: Icon(Icons.access_time_rounded,color: Colors.grey,),
                    ) ),)
                ],
              )

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
        SizedBox(width: 20,)
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate =  await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2122));

    if (_pickerDate != null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{
      debugPrint('Null value passed or something is wrong');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formatedTime = pickedTime.format(context);
    if(pickedTime == null){
      debugPrint('No time');
    }else if(isStartTime == true){
      setState(() {
        _startTime = formatedTime;
      });
    }
    else if (isStartTime == false){
      setState(() {
        _endTime = formatedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context, 
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(':')[0]),
            minute: int.parse(_startTime.split(':')[1].split(' ')[0])
        )
    );
  }
}



