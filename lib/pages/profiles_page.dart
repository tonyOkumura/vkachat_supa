import 'package:flutter/material.dart';
import 'package:vkachat_supa/models/profile.dart';
import 'package:vkachat_supa/pages/chat_page.dart';
import 'package:vkachat_supa/utils/constants.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({Key? key});

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
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.transparent,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (snapshot.data![index].id == myUserId) {
                    return Container();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        elevation: 0.0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey.shade800,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: _buildAvatar(snapshot.data![index]),
                          title: Text(
                            snapshot.data![index].username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![index].description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    personId: snapshot.data![index].id),
                              ),
                            );
                          },
                        ),
                      ),
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

  Widget _buildAvatar(Profile profile) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        profile.username.substring(0, 2),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
