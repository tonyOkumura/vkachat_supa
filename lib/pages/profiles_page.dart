import 'package:flutter/material.dart';
import 'package:vkachat_supa/models/profile.dart';
import 'package:vkachat_supa/pages/chat_page.dart';
import 'package:vkachat_supa/utils/constants.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  late Stream<List<Profile>> _profilesStream;

  @override
  void initState() {
    super.initState();
    final myUserId = supabase.auth.currentUser!.id;
    _profilesStream = supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps.map((map) => Profile.fromMap(map)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Profile>>(
        stream: _profilesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]
                      .username), // Замените на ваше поле имени пользователя
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                            personId: snapshot.data![index]
                                .id), // Замените на вашу страницу чата
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
