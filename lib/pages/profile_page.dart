import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vkachat_supa/pages/register_page.dart';
import 'package:vkachat_supa/utils/constants.dart';

import '../models/profile.dart';

class ProfilePage extends StatefulWidget {
  final String userId = supabase.auth.currentUser!.id;

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _descriptionController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile?>(
      future: getProfile(widget.userId),
      builder: (BuildContext context, AsyncSnapshot<Profile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          Profile profile = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Профиль'),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.indigo,
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard('Никнейм', profile.username),
                        SizedBox(height: 16),
                        _buildEditableInfoCard(
                          'Описание',
                          profile.description ?? 'без описания',
                          Icons.edit,
                          () {
                            _startEditing(profile.description);
                          },
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(
                          'Создан',
                          formattedDateTime(profile.createdAt),
                        ),
                        SizedBox(height: 16),
                        _buildLogoutButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Text('Профиль не найден');
        }
      },
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.indigo, // Темно-синий цвет
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableInfoCard(
    String title,
    String value,
    IconData iconData,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.indigo, // Темно-синий цвет
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    iconData,
                    size: 20,
                  ),
                  onPressed: onPressed,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: () {
        supabase.auth.signOut();
        Navigator.of(context)
            .pushAndRemoveUntil(RegisterPage.route(), (route) => false);
      },
      icon: Icon(
        Icons.exit_to_app,
        color: Colors.grey,
      ),
      label: Text(
        'Выйти',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Colors.grey[700]!, // Темно-серый цвет
        ),
      ),
    );
  }

  void _startEditing(String? currentDescription) {
    setState(() {
      _isEditing = true;
      _descriptionController.text = currentDescription ?? '';
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Править Описание'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _descriptionController,
                      maxLength: 400,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Новое описание .....',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _cancelEditing();
                  },
                  child: Text('выход'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _saveDescription();
                  },
                  child: Text('сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveDescription() async {
    final newDescription = _descriptionController.text.trim();

    try {
      if (newDescription.isNotEmpty) {
        final response = await supabase
            .from('profiles')
            .update({'description': newDescription}).eq(
                'id', supabase.auth.currentUser!.id);

        if (response != null) {
          // Ошибка при обновлении профиля
          _showSnackBar('Error updating description', Colors.red);
        } else {
          // Профиль успешно обновлен
          _showSnackBar('Description updated successfully', Colors.green);
        }
      } else {
        // Если описание пусто
        _showSnackBar('Description cannot be empty', Colors.red);
      }
    } catch (error) {
      // Обработка ошибки при обновлении профиля
      _showSnackBar('An error occurred while updating description', Colors.red);
    } finally {
      setState(() {
        _isEditing = false;
      });
    }

    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  String formattedDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }
}

Future<Profile?> getProfile(String userId) async {
  final response =
      await supabase.from('profiles').select().eq('id', userId).single();
  return Profile.fromMap(response);
}
