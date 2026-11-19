import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../theme/app_colors.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = context.read<VaultProvider>().savedName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    await context.read<VaultProvider>().saveName(_nameController.text);
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Name saved')));
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    context.read<VaultProvider>().addNote(text);
    _noteController.clear();
  }

  ThemeData _theme(bool dark) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          brightness: dark ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      );

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();

    return Theme(
      data: _theme(vault.isDark),
      child: Builder(
        builder: (context) {
          final scheme = Theme.of(context).colorScheme;
          final notes = vault.notes;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Hello, ${vault.displayName}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: SwitchListTile(
                      secondary: Icon(
                        vault.isDark ? Icons.dark_mode : Icons.light_mode,
                      ),
                      title: const Text('Dark mode'),
                      value: vault.isDark,
                      onChanged: (v) =>
                          context.read<VaultProvider>().setDark(v),
                    ),
                  ),
                  const SizedBox(height: 12),


                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _saveName(),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _saveName,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ---- Заметки ----
                  Text(
                    'Notes (${notes.length})',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addNote(),
                          decoration: const InputDecoration(
                            labelText: 'New note',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Add note',
                        onPressed: _addNote,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (notes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Icon(Icons.note_alt_outlined,
                              size: 56, color: scheme.outline),
                          const SizedBox(height: 8),
                          Text('No notes yet',
                              style: TextStyle(color: scheme.outline)),
                        ],
                      ),
                    )
                  else
                    ...notes.map(
                      (note) => Card(
                        key: ValueKey(note.id),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: note.isCompleted,
                          onChanged: (v) => context
                              .read<VaultProvider>()
                              .toggleNote(note.id, v),
                          title: Text(
                            note.title,
                            style: TextStyle(
                              decoration: note.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(note.dateText),
                          secondary: IconButton(
                            tooltip: 'Delete',
                            icon: Icon(Icons.delete_outline,
                                color: scheme.error),
                            onPressed: () => context
                                .read<VaultProvider>()
                                .deleteNote(note.id),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}