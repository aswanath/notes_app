import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/theme.dart';

import '../model/model.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  var boxNotes = Hive.box<Notes>(notesBox);
  var boxTags = Hive.box<Tags>(tagsBox);
   List<CheckBoxChange> checkbox = [];
   List<Tags> tagCheck = [];

  @override
  void initState() {
    boxTags.values.map((e){
      checkbox.add(CheckBoxChange(title: e.tagName));
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {},
            icon: Icon(Icons.notifications_active_outlined),
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
              decoration: InputDecoration(
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
            FittedBox(
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
                          textData: '26 Mar 2022, 6:00 PM', textSize: 16),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return FittedBox(
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
                        CustomText(textData: 'Productivity', textSize: 16),
                      ],
                    ),
                  ),
                ),
              );
                },
            )
          ],
        ),
      ),
    );
  }

  void labelScreen() {
    List<Tags> labelList = boxTags.values.toList();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return AlertDialog(
                title: Center(child: CustomText(textData: 'Labels', textSize: 16)),
                content: SizedBox(
                  width: 100,
                  height: 100,
                  child: ListView.builder(
                      itemCount: labelList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             SizedBox(
                               width: 100,
                                 child: CustomText(textData: checkbox[index].title, textSize: 14,textOverflow: TextOverflow.ellipsis,)),
                            Checkbox(value: checkbox[index].changed, onChanged: (val){
                            setState(() {
                             checkbox[index].changed = val!;
                            });
                            })
                          ],
                        );
                      }),
                ));},
          );
        });
  }
}
class CheckBoxChange {
  final String title;
  bool changed;

  CheckBoxChange({required this.title,this.changed=false});
}