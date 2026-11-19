import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_item.dart';

const kDarkKey = 'app_theme_dark_mode';
const kNameKey = 'user_display_name';
const kNotesKey = 'notes_json';

class VaultProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  late bool _isDark;
  late String _displayName;
  late List<NoteItem> _notes;


  VaultProvider(this._prefs) {
    _isDark = _prefs.getBool(kDarkKey) ?? false;
    _displayName = _prefs.getString(kNameKey) ?? 'Guest User';
    _notes = _loadNotes();
  }

  bool get isDark => _isDark;
  String get displayName => _displayName;

  String get savedName => _prefs.getString(kNameKey) ?? '';

  UnmodifiableListView<NoteItem> get notes => UnmodifiableListView(_notes);

  Future<void> setDark(bool value) async {
    _isDark = value;
    notifyListeners();
    await _prefs.setBool(kDarkKey, value);
  }

  Future<void> saveName(String name) async {
    final text = name.trim();
    if (text.isEmpty) {
      await _prefs.remove(kNameKey);
      _displayName = 'Guest User';
    } else {
      await _prefs.setString(kNameKey, text);
      _displayName = text;
    }
    notifyListeners();
  }

  List<NoteItem> _loadNotes() {
    final raw = _prefs.getString(kNotesKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => NoteItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveNotes() async {
    final json = jsonEncode(_notes.map((n) => n.toJson()).toList());
    await _prefs.setString(kNotesKey, json);
  }

  String _formatNow() {
    final d = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}  ${two(d.hour)}:${two(d.minute)}';
  }

  void addNote(String title) {
    final text = title.trim();
    if (text.isEmpty) return;

    _notes.insert(
      0,
      NoteItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: text,
        dateText: _formatNow(),
      ),
    );
    notifyListeners();
    _saveNotes();
  }


  void toggleNote(String id, bool? value) {
    final i = _notes.indexWhere((n) => n.id == id);
    if (i == -1) return;
    _notes[i] = _notes[i].copyWith(isCompleted: value ?? false);
    notifyListeners();
    _saveNotes();
  }


  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    _saveNotes();
  }
}