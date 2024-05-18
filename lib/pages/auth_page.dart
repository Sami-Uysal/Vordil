import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_service.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLogin = true;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _authenticate() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    User? user;
    if (_isLogin) {
      user = await _authService.signInWithEmail(email, password);
    } else {
      user = await _authService.registerWithEmail(email, password, name);
    }

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız oldu')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Giriş' : 'Kayıt'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isLogin)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
            ),
            TextButton(
              onPressed: _toggleForm,
              child: Text(_isLogin ? 'Kayıt Ol' : 'Giriş'),
            ),
          ],
        ),
      ),
    );
  }
}
