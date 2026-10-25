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

  static const Color _borderColor = Color(0xFF1F1F1F);
  static const Color _primaryColor = Color(0xFF8EC9F5);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Add Material',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1.5, color: Colors.black87),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
          children: [
            SegmentedButton<StudyMaterialType>(
              style: ButtonStyle(
                foregroundColor: const WidgetStatePropertyAll(Colors.black87),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? _primaryColor
                      : Colors.white;
                }),
                side: const WidgetStatePropertyAll(
                  BorderSide(color: _borderColor, width: 1.5),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
              _buildFieldLabel('Document'),
              const SizedBox(height: 7),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDocument,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: _borderColor, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _pickedFile?.name ?? 'Select a document...',
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ] else ...[
              _buildFieldLabel('Resource Link'),
              const SizedBox(height: 7),
              TextFormField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                decoration: _fieldDecoration(hintText: 'https://example.com'),
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
              const SizedBox(height: 18),
            ],
            _buildFieldLabel('Material Name'),
            const SizedBox(height: 7),
            TextFormField(
              controller: _titleController,
              decoration: _fieldDecoration(hintText: 'Enter material name...'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a material name.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            _buildFieldLabel('Subject'),
            const SizedBox(height: 7),
            DropdownButtonFormField<String>(
              initialValue: _subjectId,
              isExpanded: true,
              hint: const Text('Select subject...'),
              icon: const Icon(Icons.keyboard_arrow_down),
              decoration: _fieldDecoration(),
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
            _buildFieldLabel('Description (optional)'),
            const SizedBox(height: 7),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: _fieldDecoration(
                hintText: 'Enter material details...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    );
  }

  InputDecoration _fieldDecoration({
    String? hintText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      alignLabelWithHint: alignLabelWithHint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black87, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saveMaterial,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black87, width: 1.3),
                ),
              ),
              child: const Text(
                'Save Material',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black87, width: 1.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
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
