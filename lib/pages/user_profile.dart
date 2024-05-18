import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_service.dart';
import 'auth_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  late User _user;
  late String _name;
  late String _email;
  late int _level;
  bool isLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _name = _user.displayName ?? '';
    _email = _user.email ?? '';
    _level = 1;
    isLoading = false;
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _user.updateProfile(displayName: _name);
        await _user.updateEmail(_email);

        UserService userService = UserService();
        await userService.updateUserData({
          'name': _name,
          'email': _email,
          'level': _level,
        });

        setState(() {
          isEditing = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız oldu')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : isEditing
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            initialValue: _name,
                            decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lütfen kullanıcı adını giriniz';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            initialValue: _email,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lütfen email giriniz';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _updateUserData,
                            child: const Text('Kaydet'),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                            },
                            child: const Text('İptal'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _email,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Level: $_level',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
      ),
    );
  }
}
