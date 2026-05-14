import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  final TextEditingController _tokenController = TextEditingController();
  String _savedToken = 'Nenhum token carregado';

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();

    if (token.isEmpty) {
      _showMessage('Informe um token antes de salvar.');
      return;
    }

    await _storageService.saveToken(token);
    _tokenController.clear();
    _showMessage('Token salvo com segurança.');
  }

  Future<void> _loadToken() async {
    final token = await _storageService.getToken();
    setState(() {
      _savedToken = token ?? 'Nenhum token salvo.';
    });
  }

  Future<void> _deleteToken() async {
    await _storageService.deleteToken();
    setState(() {
      _savedToken = 'Token deletado.';
    });
    _showMessage('Token deletado com sucesso.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalVault'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Armazenamento Seguro',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Token fictício',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: _saveToken,
                        icon: const Icon(Icons.lock),
                        label: const Text('Salvar'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loadToken,
                        icon: const Icon(Icons.visibility),
                        label: const Text('Recuperar'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _deleteToken,
                        icon: const Icon(Icons.delete),
                        label: const Text('Deletar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Token: $_savedToken'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configurações'),
                  subtitle: const Text('Tema, idioma e notificações'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Perfil do Usuário'),
                  subtitle: const Text('Salvar, visualizar e limpar perfil'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
