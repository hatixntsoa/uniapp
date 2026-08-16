import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/teacher_entity.dart';
import '../providers/teacher_providers.dart';

/// Ticket: Gp4-1 / Gp4-2 — add/edit teacher profile, assign subjects/levels/groups, status
class TeacherFormScreen extends ConsumerStatefulWidget {
  const TeacherFormScreen({super.key, this.existing});

  final TeacherEntity? existing;

  @override
  ConsumerState<TeacherFormScreen> createState() => _TeacherFormScreenState();
}

class _TeacherFormScreenState extends ConsumerState<TeacherFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final teacher = TeacherEntity(
      id:
          widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      fullName: v['fullName'] as String,
      email: v['email'] as String,
      department: v['department'] as String,
      status: v['status'] as TeacherStatus,
      subjectIds: widget.existing?.subjectIds ?? const [],
      assignedLevels: (v['levels'] as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      assignedGroups: (v['groups'] as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );

    await ref.read(teacherListProvider.notifier).createTeacher(teacher);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.existing;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          e == null ? 'Ajouter un enseignant' : 'Modifier l\'enseignant',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'fullName': e?.fullName ?? '',
            'email': e?.email ?? '',
            'department': e?.department ?? '',
            'status': e?.status ?? TeacherStatus.actif,
            'levels': e?.assignedLevels.join(', ') ?? '',
            'groups': e?.assignedGroups.join(', ') ?? '',
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'fullName',
                decoration: const mui.InputDecoration(labelText: 'Nom complet'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'email',
                decoration: const mui.InputDecoration(labelText: 'Email'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Ce champ est requis',
                  ),
                  FormBuilderValidators.email(errorText: 'Email invalide'),
                ]),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'department',
                decoration: const mui.InputDecoration(labelText: 'Département'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<TeacherStatus>(
                name: 'status',
                decoration: const mui.InputDecoration(labelText: 'Statut'),
                items: TeacherStatus.values
                    .map(
                      (s) =>
                          mui.DropdownMenuItem(value: s, child: Text(s.label)),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'levels',
                decoration: const mui.InputDecoration(
                  labelText: 'Niveaux assignés (séparés par virgule)',
                  hintText: 'ex: L2, L3',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'groups',
                decoration: const mui.InputDecoration(
                  labelText: 'Groupes assignés (séparés par virgule)',
                  hintText: 'ex: Groupe A, Groupe B',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
