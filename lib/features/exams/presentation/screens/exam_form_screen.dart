import 'package:flutter/material.dart';
import 'package:material_ui/material_ui.dart' as mui;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/exam_entity.dart';
import '../providers/exam_providers.dart';

/// Ticket: Gp1-1 / Gp1-4 — create evaluation
/// (type, matière, groupe, date, durée, bareme, coefficient)
class ExamFormScreen extends ConsumerStatefulWidget {
  const ExamFormScreen({super.key});

  @override
  ConsumerState<ExamFormScreen> createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends ConsumerState<ExamFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final exam = ExamEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: v['title'] as String,
      type: v['type'] as ExamType,
      // Mocked: subject/teacher/group pickers use fixture IDs.
      // Wire to features/subjects, features/teachers, features/admin
      // repositories once those modules are delivered (Gp5-x, Gp4-x, Gp3-1).
      subjectId: 'sub-1',
      subjectName: v['subjectName'] as String,
      teacherId: 'u-teach-1',
      teacherName: 'Karim Haddad',
      groupId: 'grp-1',
      groupName: v['groupName'] as String,
      date: v['date'] as DateTime,
      durationMinutes: int.parse(v['duration'] as String),
      bareme: double.parse(v['bareme'] as String),
      coefficient: double.parse(v['coefficient'] as String),
    );

    await ref.read(examListProvider.notifier).createExam(exam);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer une évaluation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: const mui.InputDecoration(labelText: 'Intitulé'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<ExamType>(
                name: 'type',
                decoration: const mui.InputDecoration(
                  labelText: 'Type d\'évaluation',
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
                items: ExamType.values
                    .map(
                      (t) =>
                          mui.DropdownMenuItem(value: t, child: Text(t.label)),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'subjectName',
                decoration: const mui.InputDecoration(labelText: 'Matière'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
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
              FormBuilderDateTimePicker(
                name: 'date',
                inputType: InputType.both,
                decoration: const mui.InputDecoration(
                  labelText: 'Date et heure',
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'duration',
                      decoration: const mui.InputDecoration(
                        labelText: 'Durée (min)',
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
                      name: 'bareme',
                      decoration: const mui.InputDecoration(
                        labelText: 'bareme',
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '20',
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
              FormBuilderTextField(
                name: 'coefficient',
                decoration: const mui.InputDecoration(labelText: 'Coefficient'),
                keyboardType: TextInputType.number,
                initialValue: '1',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Requis'),
                  FormBuilderValidators.numeric(errorText: 'Nombre invalide'),
                ]),
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
