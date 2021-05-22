import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  var path = Directory.current.path;
  Hive..init(path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //主题
  TextEditingController _titleController = TextEditingController();
  //主题
  TextEditingController _messageController = TextEditingController();

  Box? box;
  List<Order> _list = [];

  @override
  void initState() {
    super.initState();
    Hive..registerAdapter(PersonAdapter());
    _readData();
  }

  void _readData() async{
    final directory = await getApplicationDocumentsDirectory();
    box = await Hive.openBox('testBox',path: directory.path);
    print(box!.values);
    // _list = (box!.values.toList().map((i) => Order.fromJson(i)).toList());
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Text("工单主题",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          ),
          Container(
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                labelText: '工单主题',
                labelStyle: TextStyle(color: Colors.grey,fontSize: 13),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
              ),
              autocorrect:false,
              controller: _titleController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black, fontSize: 13),
              onEditingComplete: () {},
            ),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("具体描述",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          ),
          Container(
            height: 150,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                labelText: '具体描述',
                labelStyle: TextStyle(color: Colors.grey,fontSize: 13),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
              ),
              minLines: 10,
              maxLines: 15,
              maxLength: 100,
              autocorrect:false,
              controller: _messageController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black, fontSize: 13),
              onEditingComplete: () {},
            ),
            alignment: Alignment.center,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Text("展示",style: TextStyle(color: Colors.white),),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: [BoxShadow(blurRadius: 3,spreadRadius: 1,color: Color.fromRGBO(0, 0, 0, 0.6),offset:Offset(3,3)),],
                      ),
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: () async{
                      FocusScope.of(context).requestFocus(FocusNode());
                      _readData();
                      setState(() {
                        _titleController.text = '';
                        _messageController.text = '';
                      });
                    },
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Text("保存",style: TextStyle(color: Colors.white),),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: [BoxShadow(blurRadius: 3,spreadRadius: 1,color: Color.fromRGBO(0, 0, 0, 0.6),offset:Offset(3,3)),],
                      ),
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: () async{
                      if(_titleController.text == ''){
                        return;
                      }
                      if(_messageController.text == ''){
                        return;
                      }
                      final directory = await getApplicationDocumentsDirectory();

                      var box = await Hive.openBox('testBox',path: directory.path);

                      var order = Order(
                        title: _titleController.text,
                        message:_messageController.text,
                      );

                      await box.put(_titleController.text, order).then((value){
                        FocusScope.of(context).requestFocus(FocusNode());
                        Hive..close();
                        _titleController.text = '';
                        _messageController.text = '';
                      }).onError((error, stackTrace){
                      });

                      setState(() {

                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _list.length,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  boxShadow: [BoxShadow(blurRadius: 3,spreadRadius: 1,color: Colors.grey,offset:Offset(0,3)),],
                ),
                child: Column(
                  children: [
                    Container(
                      child:RichText(
                        text: TextSpan(children: [
                          TextSpan(text: "工单主题:", style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                          TextSpan(text: _list[index].title, style: TextStyle(color: Colors.black, fontSize: 13)),
                        ]),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    ),//工单主题
                    Container(
                      child:RichText(
                        text: TextSpan(children: [
                          TextSpan(text: "具体描述:", style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                          TextSpan(text: _list[index].message, style: TextStyle(color: Colors.black, fontSize: 13)),
                        ]),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    ),//相关设备
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
@HiveType(typeId: 1)
class Order {
  Order({required this.title, required this.message});

  @HiveField(0)
  String title;

  @HiveField(1)
  String message;


  @override
  String toString() {
    Map data = {
      'title' :title,
      'message' : message,
    };
    return jsonEncode(data);
  }

  factory Order.fromJson(Order data) {
    return Order(
      title: data.title.toString(),
      message: data.message.toString(),
    );
  }

}
class PersonAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 1;


  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      title: fields[0].toString(),
      message: fields[1].toString(),
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PersonAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}