import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/material_file_storage.dart';
import '../../models/study_material.dart';
import '../../models/subject.dart';

class AddMaterialScreen extends StatefulWidget {
  final List<Subject> subjects;

  const AddMaterialScreen({super.key, required this.subjects});

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  StudyMaterialType _type = StudyMaterialType.document;
  String? _subjectId;
  PlatformFile? _pickedFile;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Material')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SegmentedButton<StudyMaterialType>(
              segments: const [
                ButtonSegment(
                  value: StudyMaterialType.document,
                  label: Text('Document'),
                  icon: Icon(Icons.description_outlined),
                ),
                ButtonSegment(
                  value: StudyMaterialType.link,
                  label: Text('Resource link'),
                  icon: Icon(Icons.link),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selection) {
                setState(() {
                  _type = selection.first;
                  _pickedFile = null;
                });
              },
            ),
            const SizedBox(height: 20),
            if (_type == StudyMaterialType.document) ...[
              OutlinedButton.icon(
                onPressed: _pickDocument,
                icon: const Icon(Icons.add),
                label: Text(_pickedFile?.name ?? 'Select file'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              TextFormField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Resource link',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_type != StudyMaterialType.link) return null;
                  final uri = Uri.tryParse(value?.trim() ?? '');
                  if (uri == null ||
                      !{'http', 'https'}.contains(uri.scheme) ||
                      uri.host.isEmpty) {
                    return 'Enter a valid web link.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Material name',
                hintText: 'Enter a material name...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a material name.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: _subjectId,
              decoration: const InputDecoration(
                labelText: 'Subject *',
                border: OutlineInputBorder(),
              ),
              items: widget.subjects
                  .map(
                    (subject) => DropdownMenuItem(
                      value: subject.id,
                      child: Text(subject.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _subjectId = value),
              validator: (value) =>
                  value == null ? 'Please select a subject.' : null,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter details about this material...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _saveMaterial,
                    child: const Text('Save Material'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDocument() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt', 'rtf'],
      dialogTitle: 'Select a study document',
    );

    if (!mounted || file == null) return;

    setState(() {
      _pickedFile = file;
      _titleController.text = _titleFromFileName(file.name);
    });
  }

  Future<void> _saveMaterial() async {
    if (!_formKey.currentState!.validate()) return;

    if (_type == StudyMaterialType.document && _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a document.')),
      );
      return;
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      final location = _type == StudyMaterialType.document
          ? await storePickedMaterial(_pickedFile!, id)
          : _linkController.text.trim();

      if (!mounted) {
        if (_type == StudyMaterialType.document) {
          await deleteStoredMaterial(location);
        }
        return;
      }

      Navigator.pop(
        context,
        StudyMaterial(
          id: id,
          title: _titleController.text.trim(),
          subjectId: _subjectId!,
          description: _descriptionController.text.trim(),
          type: _type,
          resourceLocation: location,
          fileName: _pickedFile?.name,
          addedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the selected material.')),
      );
    }
  }

  String _titleFromFileName(String fileName) {
    final extensionIndex = fileName.lastIndexOf('.');
    return extensionIndex <= 0
        ? fileName
        : fileName.substring(0, extensionIndex);
  }
}
