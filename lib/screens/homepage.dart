import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/navigation_drawer.dart';
import 'package:notes_app/screens/addNotes.dart';
import 'package:notes_app/theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var boxNotes = Hive.box<Notes>(notesBox);
  var boxTags = Hive.box<Tags>(tagsBox);
  IconData viewType = Icons.grid_view;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNotes()));
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      drawer: CustomDrawer(),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              toolbarHeight: deviceHeight * .085,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(22))),
                  width: deviceWidth,
                  height: deviceHeight * .065,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(Icons.menu),
                            splashRadius: .01,
                          );
                        },
                      ),
                      SizedBox(
                        width: deviceWidth * .65,
                        child: TextFormField(
                         onChanged: (val){
                           searchText = val;
                           setState(() {
                           });
                         },
                          cursorWidth: 1.5,
                          textAlignVertical: TextAlignVertical.top,
                          cursorHeight: 20,
                          decoration: const InputDecoration(
                            hintText: 'Search your notes',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (viewType == Icons.grid_view) {
                              viewType = Icons.view_list_rounded;
                            } else {
                              viewType = Icons.grid_view;
                            }
                          });
                        },
                        icon: Icon(viewType),
                        splashRadius: .01,
                      ),
                    ],
                  )),
            ),
          ];
        },
        body: ValueListenableBuilder(
          valueListenable: boxNotes.listenable(),
          builder: (BuildContext context, Box<Notes> value, Widget? child) {
            List<Notes> searchList = value.values.toList().reversed.toList().
            where((element) {
              if(element.note.toLowerCase().contains(searchText.toLowerCase())){
               return element.note.toLowerCase().contains(searchText.toLowerCase());
              }else{
                return element.title!.toLowerCase().contains(searchText.toLowerCase());
              }
            }).toList();

            List<Notes> list =searchList ;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: viewType == Icons.grid_view
                  ? StaggeredGridView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return NotesDisplay(index, context, list);
                      },
                      gridDelegate:
                          SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                              staggeredTileBuilder: (int index) {
                                return const StaggeredTile.fit(1);
                              },
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              staggeredTileCount: list.length),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: NotesDisplay(index, context, list),
                        );
                      }),
            );
          },
        ),
      ),
    );
  }

  Widget NotesDisplay(int index, BuildContext context, List<Notes> list) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddNotes(keySelected: list[index].key,)));
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: CustomText(textData: 'Delete?', textSize: 16),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: CustomText(textData: 'No', textSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        boxNotes.delete(list[index].key);
                        Navigator.pop(context);
                      },
                      child: CustomText(textData: 'Yes', textSize: 16),
                    ),
                  ],
                ));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Theme.of(context).iconTheme.color!, width: .05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            list[index].title!.isEmpty
                ? Container():Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                      child: CustomText(
                        textData: list[index].title,
                        textSize: 18,
                        textWeight: FontWeight.bold,
                      )),
                ),
            list[index].note.isNotEmpty?CustomText(textData: list[index].note, textSize: 14):Container(),
            list[index].time!=null ? Padding(
              padding: const EdgeInsets.only(top: 5),
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
                          dateFormatter.format(list[index].time!),
                          textSize: 11.5),
                    ],
                  ),
                ),
              ),
            ): Container(),
            list[index].tags!.isNotEmpty ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list[index].tags!.length,
                itemBuilder: (BuildContext context, int i) {
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
                                  textData: list[index].tags![i], textSize: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }
}
