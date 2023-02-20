# CRUD

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .envを読み込めるように設定.
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.get('VAR_URL'), // .envのURLを取得.
    anonKey: dotenv.get('VAR_ANONKEY'), // .envのanonキーを取得.
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyNotes(),
    );
  }
}

class MyNotes extends StatefulWidget {
  MyNotes({Key? key}) : super(key: key);

  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  // Streamでリアルタイムにデータを取得する.
  final _noteStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
  // Formの値を保存するTextEditingController.
  TextEditingController _body = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ), // StreamBuilderで、画面に描画する.
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _noteStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final notes = snapshot.data!;

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: const Text('Put a Note'),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                      children: [
                                        TextFormField(
                                          controller: _body,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              // Formから取得したデータを更新する.
                                              await Supabase.instance.client
                                                  .from('notes')
                                                  .update({
                                                'body': _body.text
                                              }).match({
                                                'id': notes[index]['id']
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Put'))
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            )),
                        IconButton(
                          onPressed: () async {
                            // Listのデータを受け取りMapでindexから、選択したリストのidを取得する.
                            // ボタンを押すとクエリが実行されて、データが削除される!
                            await Supabase.instance.client
                                .from('notes')
                                .delete()
                                .match({'id': notes[index]['id']});
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(notes[index]['body']), // Mapでbodyデータを取得.
                  subtitle: Text(notes[index]['created_at']), // 作成された日時を取得.
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialogのFormからデータをPostする.
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Add a Note'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  children: [
                    TextFormField(
                      controller: _body,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // Formから取得したデータを保存する.
                          await Supabase.instance.client
                              .from('notes')
                              .insert({'body': _body.text});
                          Navigator.of(context).pop();
                        },
                        child: Text('Post'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

リファクタリングしたコード
```dart
class MyNotes extends StatefulWidget {
  MyNotes({Key? key}) : super(key: key);

  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  // Streamでリアルタイムにデータを取得する.
  final _noteStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
  // Formの値を保存するTextEditingController.
  TextEditingController _body = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = DataBaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ), // StreamBuilderで、画面に描画する.
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _noteStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final notes = snapshot.data!;

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: const Text('Put a Note'),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                      children: [
                                        TextFormField(
                                          controller: _body,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              final noteID = notes[index]['id'];
                                              // Formから取得したデータを更新する.
                                              // await Supabase.instance.client
                                              //     .from('notes')
                                              //     .update({
                                              //   'body': _body.text
                                              // }).match({
                                              //   'id': noteID
                                              // });
                                              service.updateNotes(
                                                  noteID, _body.text);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Put'))
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            )),
                        IconButton(
                          onPressed: () async {
                            final noteID = notes[index]['id'];
                            // Listのデータを受け取りMapでindexから、選択したリストのidを取得する.
                            // ボタンを押すとクエリが実行されて、データが削除される!
                            // await Supabase.instance.client
                            //     .from('notes')
                            //     .delete()
                            //     .match({'id': notes[index]['id']});
                            service.deleteNotes(noteID);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(notes[index]['body']), // Mapでbodyデータを取得.
                  subtitle: Text(notes[index]['created_at']), // 作成された日時を取得.
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialogのFormからデータをPostする.
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Add a Note'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  children: [
                    TextFormField(
                      controller: _body,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // Formから取得したデータを保存する.
                          // await Supabase.instance.client
                          //     .from('notes')
                          //     .insert({'body': _body.text});
                          service.addNotes(_body.text);
                          Navigator.of(context).pop();
                        },
                        child: Text('Post'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```