import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  final _future = Supabase.instance.client
      .from('notes')
      .select<List<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: ((context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['body']),
                subtitle: Text(note['created_at']),
              );
            }),
          );
        },
      ),
    );
  }
}