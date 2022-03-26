import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class Notes extends HiveObject{
  @HiveField(0)
  String? title;
  
  @HiveField(1)
  String note;

  @HiveField(2)
  DateTime? time;

  @HiveField(3)
  List<String>? tags;

  Notes({this.title,required this.note,this.time,this.tags});
}

@HiveType(typeId: 1)
class Tags extends HiveObject{
  @HiveField(0)
  String tagName;

  Tags({required this.tagName});
}