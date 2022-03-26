import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/screens/homepage.dart';
import 'package:notes_app/screens/trash.dart';

import 'model/model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  var tagBox = Hive.box<Tags>(tagsBox);
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 13, top: 10),
          child: ListView(children: [
            CustomText(textData: 'Notes Assistant', textSize: 23),
            Divider(),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: CustomText(textData: 'Notes', textSize: 16),
              contentPadding: EdgeInsets.zero,
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
              },
            ),
            ListTile(
              onTap: (){
                _labelAddEdit('');
              },
              leading: Icon(Icons.add),
              title: CustomText(textData: 'Create new label', textSize: 16),
              contentPadding: EdgeInsets.zero,
            ),
            ValueListenableBuilder(
              valueListenable: tagBox.listenable(),
              builder: (BuildContext context,Box<Tags> newTagBox, Widget? child) {
                List<Tags> tagList = newTagBox.values.toList();
                return tagList.isEmpty ? SizedBox() :
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: CustomText(textData: 'Labels', textSize: 14),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: tagList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          leading: Icon(Icons.label_outline),
                          title: CustomText(textData: tagList[index].tagName, textSize: 14),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: (){
                                _labelAddEdit(tagList[index].tagName,key: tagList[index].key);
                              }, icon: Icon(Icons.edit_outlined),padding: EdgeInsets.zero,visualDensity: VisualDensity(horizontal: 0),),
                              IconButton(onPressed: (){
                                tagBox.delete(tagList[index].key);
                              }, icon: Icon(Icons.delete_outline_sharp),padding: EdgeInsets.zero,visualDensity: VisualDensity(horizontal: 0)),
                            ],
                          ),
                        );
                      }),
                  Divider(),
                ],
              );},
            ),
            // ListTile(
            //   leading: Icon(Icons.delete_outline_sharp),
            //   title: CustomText(textData: 'Trash', textSize: 16),
            //   contentPadding: EdgeInsets.zero,
            //   onTap: (){
            //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TrashPage()));
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.dark_mode_outlined),
            //   title: CustomText(textData: 'Dark mode', textSize: 16),
            //   trailing: Switch(
            //       value: switchValue, onChanged: (val) {
            //    setState(() {
            //      switchValue = val;
            //    });
            //   }),
            //   contentPadding: EdgeInsets.zero,
            // ),
          ]),
        ),
      ),
    );
  }

  void _labelAddEdit(String text,{int? key}) {
    TextEditingController textEditingController = TextEditingController();
    if(text.isNotEmpty){
      textEditingController.text = text;
    }
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Center(child: CustomText(textData: 'Create', textSize: 16,textWeight: FontWeight.w600,)),
      content: SizedBox(width: 100,height: 100,child: Column(
        children: [
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).iconTheme.color!)
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).iconTheme.color!)
              ),
            ),
          ),
          ElevatedButton(onPressed: (){
            if(textEditingController.text.isNotEmpty){
              if(text.isNotEmpty){
                tagBox.put(key, Tags(tagName: textEditingController.text));
              }else{
                tagBox.add(Tags(tagName: textEditingController.text));
              }
            }
            Navigator.pop(context);
          }, child: CustomText(textData: 'Save', textSize: 16))
        ],
      ),),
    ));
  }
}
