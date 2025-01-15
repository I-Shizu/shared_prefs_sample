import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController toDoTextController = TextEditingController();
  List<String> toDoList = [];

  Future<void> getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      toDoList = prefs.getStringList('toDoList') ?? [];
    });
  }

  Future<void> setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('toDoList', toDoList);
  }

  Future<void> deletePrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    getPrefsItems();
  }

  @override
  void dispose() {
    toDoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
      ),

      body: Column(
        children: [
          Column(
            spacing: 16,
            children: [
              const SizedBox(),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: toDoTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'やること', 
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    //リストに追加
                    toDoList.add(toDoTextController.text);
                    //データに保存
                    setPrefsItems();
                    //テキストコントローラーをリセット
                    toDoTextController.clear();
                  });
                }, 
                child: const Text('追加')
              )
            ],
          ),
          Expanded(
            child: toDoList.isEmpty
              ? const Center(child: Text('やることはありません'),)
              : ListView.builder(
                itemCount: toDoList.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(toDoList[index]),
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
}