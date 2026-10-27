import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:studynest/utils/subject_ordering.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';
import '../data/material_file_storage.dart';
import '../models/study_material.dart';
import '../widgets/resource_document_picker.dart';

class ResourceFormScreen extends StatefulWidget {
  final List<Subject> subjects;
  final StudyMaterial? initialMaterial;

  const ResourceFormScreen({
    super.key,
    required this.subjects,
    this.initialMaterial,
  });

  @override
  State<ResourceFormScreen> createState() => _ResourceFormScreenState();
}

class _ResourceFormScreenState extends State<ResourceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(
    text: widget.initialMaterial?.title ?? '',
  );
  late final _descriptionController = TextEditingController(
    text: widget.initialMaterial?.description ?? '',
  );
  late final _linkController = TextEditingController(
    text: widget.initialMaterial?.type == StudyMaterialType.link
        ? widget.initialMaterial!.resourceLocation
        : '',
  );

  late StudyMaterialType _type =
      widget.initialMaterial?.type ?? StudyMaterialType.document;
  late String? _subjectId = widget.initialMaterial?.subjectId;
  PlatformFile? _pickedFile;

  bool get _isEditing => widget.initialMaterial != null;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjectsInPickerOrder = orderSubjectsForPicker(widget.subjects);

    return Scaffold(
      backgroundColor: AppTheme.canvas,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          _isEditing ? 'Edit Resource' : 'Add Material',
          style: TextStyle(
            color: AppTheme.ink,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            _buildTypeControl(),
            const SizedBox(height: 20),
            if (_type == StudyMaterialType.document) ...[
              ResourceDocumentPicker(
                fileName: _pickedFile?.name ?? widget.initialMaterial?.fileName,
                isEditing: _isEditing,
                onTap: _pickDocument,
              ),
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
              items: subjectsInPickerOrder
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
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.ink),
    );
  }

  Widget _buildTypeControl() {
    if (_isEditing) {
      final isDocument = _type == StudyMaterialType.document;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.outline),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isDocument ? Icons.description_outlined : Icons.link,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 10),
            Text(isDocument ? 'Document' : 'Resource link'),
          ],
        ),
      );
    }

    return SegmentedButton<StudyMaterialType>(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(AppTheme.primary),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? const Color(0xFFDCE8F8)
              : Colors.white;
        }),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppTheme.outline),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
    );
  }

  InputDecoration _fieldDecoration({
    String? hintText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      alignLabelWithHint: alignLabelWithHint,
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
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _isEditing ? 'Save Changes' : 'Save Material',
                style: const TextStyle(fontWeight: FontWeight.w600),
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
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
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
      if (!_isEditing) {
        _titleController.text = _titleFromFileName(file.name);
      }
    });
  }

  Future<void> _saveMaterial() async {
    if (!_formKey.currentState!.validate()) return;

    if (_type == StudyMaterialType.document &&
        _pickedFile == null &&
        widget.initialMaterial?.type != StudyMaterialType.document) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a document.')),
      );
      return;
    }

    final id =
        widget.initialMaterial?.id ??
        DateTime.now().microsecondsSinceEpoch.toString();
    String? newlyStoredPath;

    try {
      final String location;
      if (_type == StudyMaterialType.document && _pickedFile != null) {
        final storageId = _isEditing
            ? '$id-${DateTime.now().microsecondsSinceEpoch}'
            : id;
        location = await storePickedMaterial(_pickedFile!, storageId);
        newlyStoredPath = location;
      } else if (_type == StudyMaterialType.document) {
        location = widget.initialMaterial!.resourceLocation;
      } else {
        location = _linkController.text.trim();
      }

      if (!mounted) {
        if (newlyStoredPath != null) {
          await deleteStoredMaterial(newlyStoredPath);
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
          fileName: _type == StudyMaterialType.document
              ? _pickedFile?.name ?? widget.initialMaterial?.fileName
              : null,
          addedAt: widget.initialMaterial?.addedAt ?? DateTime.now(),
        ),
      );
    } catch (_) {
      if (newlyStoredPath != null) {
        await deleteStoredMaterial(newlyStoredPath);
      }
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
