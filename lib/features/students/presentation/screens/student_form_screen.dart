import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/student_entity.dart';
import '../providers/student_providers.dart';

/// Ticket: Gp2-1 — add/edit student, assign level/filière/group/year
class StudentFormScreen extends ConsumerStatefulWidget {
  const StudentFormScreen({super.key, this.existing});

  final StudentEntity? existing;

  @override
  ConsumerState<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends ConsumerState<StudentFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final student = StudentEntity(
      id: widget.existing?.id ?? const Uuid().v4(),
      fullName: v['fullName'] as String,
      matricule: v['matricule'] as String,
      email: v['email'] as String,
      filiere: v['filiere'] as String,
      niveau: v['niveau'] as String,
      groupName: v['groupName'] as String,
      anneeUniversitaire: v['annee'] as String,
    );

    await ref.read(studentListProvider.notifier).createStudent(student);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.existing;
    return Scaffold(
      appBar: AppBar(
        title: Text(e == null ? 'Ajouter un étudiant' : 'Modifier l\'étudiant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'fullName': e?.fullName ?? '',
            'matricule': e?.matricule ?? '',
            'email': e?.email ?? '',
            'filiere': e?.filiere ?? '',
            'niveau': e?.niveau ?? 'L1',
            'groupName': e?.groupName ?? '',
            'annee': e?.anneeUniversitaire ?? '2025/2026',
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
                name: 'matricule',
                decoration: const mui.InputDecoration(labelText: 'Matricule'),
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
                name: 'filiere',
                decoration: const mui.InputDecoration(labelText: 'Filière'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<String>(
                name: 'niveau',
                decoration: const mui.InputDecoration(labelText: 'Niveau'),
                items: ['L1', 'L2', 'L3', 'M1', 'M2']
                    .map((n) => mui.DropdownMenuItem(value: n, child: Text(n)))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'groupName',
                decoration: const mui.InputDecoration(labelText: 'Groupe'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'annee',
                decoration: const mui.InputDecoration(
                  labelText: 'Année universitaire',
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
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
