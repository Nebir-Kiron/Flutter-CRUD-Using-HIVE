import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController todoControler = TextEditingController();
  TextEditingController updateController = TextEditingController();

  var box = Hive.box('box');


  Future<void> addData() async {
    int num = box.length + 1;
    if(todoControler.text != ''){
      num++;
      setState(() {
        box.put(num, todoControler.text);
      });
      todoControler.clear();
      Navigator.pop(context);
    }
  }

  void editTask(int index){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text("Edit Text"),
        content: TextFormField(
          controller: updateController,
          autofocus: true,
          enableSuggestions: true,
          decoration: InputDecoration(
              hintText: box.getAt(index),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              )),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              todoControler.clear();
            },
            child: Text('Cancel'),
          ),

          TextButton(
            onPressed: () {
              if (updateController.text != '') {
                setState(() {
                  box.putAt(index, updateController.text);
                });
                updateController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Update'),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Task"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    child: ListTile(
                      onTap: ()=> editTask(index),
                      tileColor: Colors.primaries[index % Colors.primaries.length],
                      title: Text(box.getAt(index)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      trailing: IconButton(
                        onPressed: (){
                          setState(() {
                            box.deleteAt(index);
                          });
                        },
                        icon: Icon(Icons.delete,color: Colors.white,),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        onPressed: (){
          showModalBottomSheet(
              context: context,
              builder: (BuildContext Context){
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        'Add ToDo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.primaries[
                          Random().nextInt(Colors.primaries.length)],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        autofocus: true,
                        onEditingComplete: addData,
                        enableSuggestions: true,
                        controller: todoControler,
                        decoration: InputDecoration(
                            labelText: 'Write Something',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          height: 45,
                          color: Colors.primaries[
                          Random().nextInt(Colors.primaries.length)],
                          onPressed: () {
                            addData();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Add your Data',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
