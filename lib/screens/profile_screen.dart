import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  late final Box<UserProfile> _profileBox;

  @override
  void initState() {
    super.initState();
    _profileBox = Hive.box<UserProfile>('userProfileBox');
    _loadProfileIntoFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void _loadProfileIntoFields() {
    final profile = _profileBox.get('profile');
    if (profile != null) {
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _scoreController.text = profile.score.toString();
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final score = int.tryParse(_scoreController.text.trim()) ?? 0;

    if (name.isEmpty || email.isEmpty) {
      _showMessage('Informe nome e e-mail.');
      return;
    }

    final existingProfile = _profileBox.get('profile');

    final profile = UserProfile(
      name: name,
      email: email,
      registrationDate: existingProfile?.registrationDate ?? DateTime.now(),
      score: score,
    );

    await _profileBox.put('profile', profile);
    _showMessage('Perfil salvo com sucesso.');
  }

  Future<void> _clearProfile() async {
    await _profileBox.delete('profile');
    _nameController.clear();
    _emailController.clear();
    _scoreController.clear();
    _showMessage('Dados do perfil apagados.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _profileBox.listenable(),
        builder: (context, Box<UserProfile> box, _) {
          final profile = box.get('profile');

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salvar perfil',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _scoreController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Pontuação',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _saveProfile,
                              icon: const Icon(Icons.save),
                              label: const Text('Salvar'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _clearProfile,
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('Limpar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: profile == null
                      ? const Text('Nenhum perfil salvo.')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Perfil salvo',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Text('Nome: ${profile.name}'),
                            Text('E-mail: ${profile.email}'),
                            Text(
                              'Cadastro: ${dateFormat.format(profile.registrationDate)}',
                            ),
                            Text('Pontuação: ${profile.score}'),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
