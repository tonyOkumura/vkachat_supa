import 'package:flutter/material.dart';
import 'package:vkachat_supa/pages/register_page.dart';
import 'package:vkachat_supa/utils/constants.dart';

import '../models/profile.dart';

class ProfilePage extends StatelessWidget {
  final String userId = supabase.auth.currentUser!.id;

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile?>(
      future: getProfile(userId),
      builder: (BuildContext context, AsyncSnapshot<Profile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          Profile profile = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile Page'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    supabase.auth.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        RegisterPage.route(), (route) => false);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'User ID: ${profile.id}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Username: ${profile.username}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Created At: ${profile.createdAt}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Text('No profile found');
        }
      },
    );
  }
}

Future<Profile?> getProfile(String userId) async {
  final response =
      await supabase.from('profiles').select().eq('id', userId).single();
  return Profile.fromMap(response);
}
