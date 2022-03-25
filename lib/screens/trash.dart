import 'package:flutter/material.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/navigation_drawer.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).iconTheme.color,
        elevation: 0,
        title: CustomText(textData: 'Trash', textSize: 18,),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(child: Center(child: Text('trash'),)),
    );
  }
}
