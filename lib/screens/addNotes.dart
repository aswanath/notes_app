import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/theme.dart';

import '../model/model.dart';
import '../notification.dart';

class AddNotes extends StatefulWidget {
  final int? keySelected;
   AddNotes({Key? key, this.keySelected}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  var boxNotes = Hive.box<Notes>(notesBox);
  var boxTags = Hive.box<Tags>(tagsBox);
  List<CheckBoxChange> checkbox = [];
  late List<Tags> labelList;
   DateTime? selectedDate;
   TimeOfDay? selectedTime;

  @override
  void initState() {
    labelList = boxTags.values.toList();
      boxTags.values.map((e) {
        checkbox.add(CheckBoxChange(title: e.tagName));
      }).toList();
    if(widget.keySelected!=null){
      Notes element = boxNotes.get(widget.keySelected)!;
      titleController.text = element.title!;
      notesController.text = element.note;
      selectedDate = element.time!=null?DateTime(element.time!.year,element.time!.month,element.time!.day):null;
      selectedTime = element.time!=null?TimeOfDay(hour: element.time!.hour, minute: element.time!.minute,):null;
      if(element.tags!.isNotEmpty){
        element.tags!.map((elem){
         checkbox.map((e) {
           if(e.title==elem){
             e.changed=true;
           }
         }).toList();
        }).toList();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (notesController.text.isNotEmpty&&widget.keySelected==null) {
          boxNotes.add(Notes(
              note: notesController.text,
              title: titleController.text,
              time: (selectedDate!=null)?DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                  00):null,
            tags: checkedList()
          ));
          if(selectedDate!=null){
            createReminderNotification(DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                selectedTime!.hour,
                selectedTime!.minute,
                00),title: titleController.text,note: notesController.text);
          }
        }else{
          boxNotes.put(widget.keySelected,
              Notes(
                  note: notesController.text,
                  title: titleController.text,
                  time: (selectedDate!=null)?DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                      00):null,
                  tags: checkedList()
              )
          );
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                labelScreen();
              },
              icon: Icon(Icons.label_outline),
              splashRadius: 20,
            ),
            IconButton(
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: selectedDate??DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 5))
                    .then((value) {
                  if (value != null) {
                    selectedDate = value;
                    showTimePicker(context: context, initialTime: selectedTime??TimeOfDay.now())
                        .then((value) {
                      if (value != null) {
                        selectedTime = value;
                        setState(() {});
                      }
                    });
                  }
                });
              },
              icon: const Icon(Icons.notifications_active_outlined),
              splashRadius: 20,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(fontSize: 18),
                cursorWidth: 1,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(fontSize: 20),
                    hintText: 'Title',
                    border: InputBorder.none),
              ),
              Container(
                width: deviceWidth,
                child: TextField(
                  controller: notesController,
                  autofocus: true,
                  maxLines: null,
                  cursorWidth: 1,
                  cursorHeight: 20,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(fontSize: 16),
                      hintText: 'Note',
                      border: InputBorder.none),
                ),
              ),
              (selectedDate!=null)
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Icon(Icons.alarm),
                              SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                  textData:
                                      '${dateFormat.format(selectedDate!)} ${selectedTime!.format(context)}',
                                  textSize: 16),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: checkedList().length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              CustomText(
                                  textData: checkedList()[index], textSize: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void labelScreen() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                  title: Center(
                      child: CustomText(
                          textData: checkbox.isEmpty ? 'No labels' : 'Labels',
                          textSize: 16)),
                  content: SizedBox(
                    width: 100,
                    height: checkbox.isEmpty ? 0 : 100,
                    child: ListView.builder(
                        itemCount: checkbox.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: CustomText(
                                    textData: checkbox[index].title,
                                    textSize: 14,
                                    textOverflow: TextOverflow.ellipsis,
                                  )),
                              Checkbox(
                                  value: checkbox[index].changed,
                                  onChanged: (val) {
                                    setState(() {
                                      checkbox[index].changed = val!;
                                    });
                                  })
                            ],
                          );
                        }),
                  ));
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  List<String> checkedList() {
    List<String> list = [];
    checkbox.map((e) {
      if (e.changed == true) {
        list.add(e.title);
      }
    }).toList();
    return list;
  }

}

class CheckBoxChange {
  final String title;
  bool changed;

  CheckBoxChange({required this.title, this.changed = false});
}
