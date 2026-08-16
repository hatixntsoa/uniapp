import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' as mui;
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/subject_entity.dart';
import '../providers/subject_providers.dart';

/// Ticket: Gp5-1 — create subject (code, coefficient, volume horaire, semestre, niveau, enseignant)
class SubjectFormScreen extends ConsumerStatefulWidget {
  const SubjectFormScreen({super.key});

  @override
  ConsumerState<SubjectFormScreen> createState() => _SubjectFormScreenState();
}

class _SubjectFormScreenState extends ConsumerState<SubjectFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final subject = SubjectEntity(
      id: const Uuid().v4(),
      code: v['code'] as String,
      name: v['name'] as String,
      coefficient: double.parse(v['coefficient'] as String),
      volumeHoraire: int.parse(v['volumeHoraire'] as String),
      semestre: v['semestre'] as String,
      niveau: v['niveau'] as String,
      filiere: v['filiere'] as String,
      // Mocked: teacher picker is free-text until features/teachers
      // exposes a searchable dropdown provider shared across modules.
      teacherId: 'u-teach-1',
      teacherName: v['teacherName'] as String,
    );

    await ref.read(subjectListProvider.notifier).createSubject(subject);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer une matière')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'code',
                decoration: const mui.InputDecoration(labelText: 'Code'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'name',
                decoration: const mui.InputDecoration(labelText: 'Intitulé'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'coefficient',
                      decoration: const mui.InputDecoration(
                        labelText: 'Coefficient',
                      ),
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Requis'),
                        FormBuilderValidators.numeric(
                          errorText: 'Nombre invalide',
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'volumeHoraire',
                      decoration: const mui.InputDecoration(
                        labelText: 'Volume horaire (h)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Requis'),
                        FormBuilderValidators.numeric(
                          errorText: 'Nombre invalide',
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<String>(
                name: 'semestre',
                decoration: const mui.InputDecoration(labelText: 'Semestre'),
                items: const ['Semestre 1', 'Semestre 2']
                    .map((s) => mui.DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<String>(
                name: 'niveau',
                decoration: const mui.InputDecoration(labelText: 'Niveau'),
                items: const ['L1', 'L2', 'L3', 'M1', 'M2']
                    .map((n) => mui.DropdownMenuItem(value: n, child: Text(n)))
                    .toList(),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
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
              FormBuilderTextField(
                name: 'teacherName',
                decoration: const mui.InputDecoration(
                  labelText: 'Enseignant assigné',
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
