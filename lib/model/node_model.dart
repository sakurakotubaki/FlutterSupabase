import 'package:supabase_flutter/supabase_flutter.dart';
// 追加・更新・削除の処理を使えるクラス.
class DataBaseService {
  // ゲッターを作成して、インスタンス化したSupabaseClientを渡す.
  SupabaseClient get client => Supabase.instance.client;
  // データを追加するメソッド.
  Future<void> addNotes(String _body) async {
    // Formから取得したデータを保存する.
    await client.from('notes').insert({'body': _body});
  }
  // データを更新するメソッド.
  Future<void> updateNotes(dynamic noteID, String _body) async {
    await client.from('notes').update({'body': _body}).match({'id': noteID});
  }
  // データを削除するメソッド.
  Future<void> deleteNotes(dynamic noteID) async {
    await client.from('notes').delete().match({'id': noteID});
  }
}
