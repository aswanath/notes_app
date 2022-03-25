import 'package:flutter/material.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/navigation_drawer.dart';
import 'package:notes_app/screens/addNotes.dart';
import 'package:notes_app/theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData viewType = Icons.grid_view;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNotes()));
      },child: Icon(Icons.add,size: 35,),),
      drawer:  CustomDrawer(),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: viewType == Icons.grid_view
              ? StaggeredGridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return NotesDisplay(index, context);
                  },
                  gridDelegate:
                      SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                          staggeredTileBuilder: (int index) {
                            return const StaggeredTile.fit(1);
                          },
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          staggeredTileCount: 200),
                )
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 200,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: NotesDisplay(index, context),
                );
              })),
        ),
      );
  }
}

Widget NotesDisplay(int index, BuildContext context) {
  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNotes()));
    },
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border:
              Border.all(color: Theme.of(context).iconTheme.color!, width: .05)),
      child: CustomText(textData: 'OMHGGGG $index', textSize: 16),
    ),
  );
}
