import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/presentation_entity.dart';
import '../providers/presentation_providers.dart';

/// Ticket: Gp10-1 — create presentation (individual/group, members, order, grading criteria)
class PresentationFormScreen extends ConsumerStatefulWidget {
  const PresentationFormScreen({super.key});

  @override
  ConsumerState<PresentationFormScreen> createState() =>
      _PresentationFormScreenState();
}

class _PresentationFormScreenState
    extends ConsumerState<PresentationFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final memberNames = (v['members'] as String)
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final presentation = PresentationEntity(
      id: const Uuid().v4(),
      title: v['title'] as String,
      mode: v['mode'] as PresentationMode,
      subjectName: v['subjectName'] as String,
      date: v['date'] as DateTime,
      members: [
        for (var i = 0; i < memberNames.length; i++)
          PresentationMember(
            studentId: 'student-${i + 1}',
            studentName: memberNames[i],
            order: i + 1,
          ),
      ],
      // Default grading criteria; a real integration would let the
      // enseignant customize these per presentation.
      criteria: const [
        GradingCriterion(id: 'c-content', label: 'Contenu', maxPoints: 8),
        GradingCriterion(
          id: 'c-support',
          label: 'Support visuel',
          maxPoints: 4,
        ),
        GradingCriterion(id: 'c-oral', label: 'Aisance orale', maxPoints: 4),
        GradingCriterion(
          id: 'c-qa',
          label: 'Réponses aux questions',
          maxPoints: 4,
        ),
      ],
    );

    await ref
        .read(presentationListProvider.notifier)
        .createPresentation(presentation);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planifier une présentation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          initialValue: const {'mode': PresentationMode.groupe},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: const mui.InputDecoration(labelText: 'Titre'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<PresentationMode>(
                name: 'mode',
                decoration: const mui.InputDecoration(labelText: 'Mode'),
                items: PresentationMode.values
                    .map(
                      (m) =>
                          mui.DropdownMenuItem(value: m, child: Text(m.label)),
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
              FormBuilderTextField(
                name: 'members',
                decoration: const mui.InputDecoration(
                  labelText:
                      'Participants (séparés par virgule, dans l\'ordre)',
                  hintText: 'ex: Lina Meziane, Yanis Kaci',
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
