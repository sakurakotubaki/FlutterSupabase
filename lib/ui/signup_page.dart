import 'package:flutter/material.dart';
import 'package:supabase_app/model/auth_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final supabase = Supabase.instance.client;
    final authModel = AuthModel();

    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _email,
            ),
            TextField(
              controller: _password,
            ),
            ElevatedButton(
                onPressed: () async {
                  // final AuthResponse res = await supabase.auth.signUp(
                  //   email: _email.text,
                  //   password: _password.text,
                  // );
                  // final Session? session = res.session;
                  // final User? user = res.user;
                  authModel.signUp(_email.text, _password.text, context);
                },
                child: Text('SignUp'))
          ],
        ),
      ),
    );
  }
}
