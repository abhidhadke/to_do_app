import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/models/tasks.dart';
import 'package:to_do_list/ui/themes.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task?.color??0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.title??"",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${task!.startTime} - ${task!.endTime}",
                      style: GoogleFonts.poppins(
                        textStyle:
                        TextStyle(fontSize: 13, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
               Visibility(
                 visible: !(task!.repeat == 'None'),
                   child: Column(
                 children: [
                   const SizedBox(height: 5,),
                   Row(
                     children: [
                       Icon
                         (Icons.arrow_right_rounded,
                         color: Colors.grey[200],
                         size: 18,
                       ),
                       Text("${_getReminder(task!.repeat!)} reminder",
                       style: GoogleFonts.poppins(
                         textStyle: TextStyle(
                             fontSize: 15,
                             color: Colors.grey[100]
                         )
                       ),
                       ),

                     ],
                   ),
                 ],
               )),
                const SizedBox(height: 10),
                Text(
                  task?.note??"",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return pinkClr;
      case 1:
        return yellowClr;
      case 2:
        return bluishClr;
      default:
        return bluishClr;
    }
  }

  _getReminder(String repeat){
    switch(repeat){
      case 'None':
        return '';
      case 'Daily':
        return 'Daily';
      case 'Weekly':
        return 'Weekly';
      case 'Monthly':
        return 'Monthly';
      default:
        return '';
    }
  }
}