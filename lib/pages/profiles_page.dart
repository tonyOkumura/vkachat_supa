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
    final myUserId = supabase.auth.currentUser!.id;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<Profile>>(
          stream: _profilesStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (snapshot.data![index].id == myUserId) {
                    return Container();
                  } else {
                    return ListTile(
                      title: Text(snapshot.data![index].username),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(personId: snapshot.data![index].id),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
