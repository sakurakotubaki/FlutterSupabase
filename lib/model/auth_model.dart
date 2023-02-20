import 'package:flutter/material.dart';
import 'package:supabase_app/ui/signin_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 認証機能をまとめたクラス.
class AuthModel {
  // ゲッターを作成して、インスタンス化したSupabaseClientを渡す.
  SupabaseClient get supabase => Supabase.instance.client;

  // ユーザーの新規登録をするメソッド.
  Future<void> signUp(
      String _email, String _password, BuildContext context) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: _email,
        password: _password,
      );
      final Session? session = res.session;
      final User? user = res.user;
    } catch (e) {
      print('error!: $e');
    }
  }
  // ログインをするメソッド.
  Future<void> signInWithEmail(
      String _email, String _password, BuildContext context) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _email,
        password: _password,
      );
      final Session? session = res.session;
      final User? user = res.user;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('error!: $e');
    }
  }
  // ログアウトするメソッド.
  Future<void> signOut(BuildContext context) async {
    await supabase.auth.signOut();
    Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SigninPage()));
  }
}
