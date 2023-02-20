import 'package:flutter/material.dart';
import 'package:supabase_app/model/auth_model.dart';
import 'package:supabase_app/ui/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SigninPage extends StatefulWidget {
  SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final supabase = Supabase.instance.client;
    final authModel = AuthModel();

    return Scaffold(
      appBar: AppBar(
        title: Text('SignIn'),
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
                  // try {
                  //   final AuthResponse res =
                  //       await supabase.auth.signInWithPassword(
                  //     email: _email.text,
                  //     password: _password.text,
                  //   );
                  //   final Session? session = res.session;
                  //   final User? user = res.user;
                  //   Navigator.of(context).pushReplacement(
                  //       MaterialPageRoute(builder: (context) => HomePage()));
                  // } catch (e) {
                  //   print('error!: $e');
                  // }
                  authModel.signInWithEmail(
                      _email.text, _password.text, context);
                },
                child: Text('SignIn')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: Text('SignUp'))
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final supabase = Supabase.instance.client;
    final authModel = AuthModel();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                // await supabase.auth.signOut();
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => SigninPage()));
                authModel.signOut(context);
              },
              icon: Icon(Icons.logout))
        ],
        title: Text('Welcome!'),
      ),
      body: Center(child: Text('Welcome!')),
    );
  }
}
