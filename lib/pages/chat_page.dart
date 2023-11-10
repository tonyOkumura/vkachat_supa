import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';
import 'package:vkachat_supa/models/message.dart';
import 'package:vkachat_supa/models/profile.dart';
import 'package:vkachat_supa/utils/constants.dart';

class ChatPage extends StatefulWidget {
  final String personId;

  const ChatPage({required this.personId, Key? key}) : super(key: key);

  static Route<void> route({required String personId}) {
    return MaterialPageRoute(
      builder: (context) => ChatPage(
        personId: personId,
      ),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String chatId;
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;

    final myUserId = supabase.auth.currentUser!.id;
    chatId = myUserId.hashCode <= widget.personId.hashCode
        ? '$myUserId-${widget.personId}'
        : '${widget.personId}-$myUserId';

    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .eq('chat_id', chatId)
        .map((maps) => maps
            .map((map) => Message.fromMap(map: map, myUserId: myUserId))
            .toList());
  }

  Future<void> _loadProfileCache(String profileId) async {
    if (_mounted) {
      if (_profileCache[profileId] == null) {
        final data = await supabase
            .from('profiles')
            .select()
            .eq('id', profileId)
            .single();

        final profile = Profile.fromMap(data);
        if (_mounted) {
          setState(() {
            _profileCache[profileId] = profile;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: StreamBuilder<List<Message>>(
          stream: _messagesStream,
          builder: (context, snapshot) {
            if (_mounted) {
              if (snapshot.hasData) {
                final messages = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: messages.isEmpty
                          ? const Center(
                              child: Text('Start your conversation now :)'),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                _loadProfileCache(message.profileId);

                                return _ChatBubble(
                                  message: message,
                                  profile: _profileCache[message.profileId],
                                );
                              },
                            ),
                    ),
                    _MessageBar(chatId: chatId),
                  ],
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.indigo,
                ));
              }
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

class _MessageBar extends StatefulWidget {
  final String chatId;

  const _MessageBar({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _submitMessage(widget.chatId),
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage(String chatId) async {
    final text = _textController.text;
    final myUserId = supabase.auth.currentUser!.id;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('messages').insert({
        'chat_id': chatId,
        'profile_id': myUserId,
        'content': text,
      });
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final backgroundColor = isMine
        ? Theme.of(context).primaryColor
        : Colors.deepPurple; // Используйте цвет для сообщений собеседника
    final textColor = isMine
        ? Colors.white
        : Colors.white; // Используйте цвет текста для сообщений

    List<Widget> chatContents = [
      if (!isMine)
        CircleAvatar(
          child: profile == null
              ? const CircularProgressIndicator()
              : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(
        format(message.createdAt, locale: 'en_short'),
      ),
      const SizedBox(width: 60),
    ];
    if (isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
