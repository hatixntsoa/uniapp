import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/activity_entity.dart';
import '../providers/activity_providers.dart';

/// Ticket: Gp7-1/7-2 — create activity (type, date, lieu, responsable, places, description)
/// Ticket: Gp7-3 — publish
class ActivityFormScreen extends ConsumerStatefulWidget {
  const ActivityFormScreen({super.key});

  @override
  ConsumerState<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends ConsumerState<ActivityFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save({required bool publish}) async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final activity = ActivityEntity(
      id: const Uuid().v4(),
      title: v['title'] as String,
      type: v['type'] as ActivityType,
      date: v['date'] as DateTime,
      location: v['location'] as String,
      responsibleName: v['responsibleName'] as String,
      totalSeats: int.parse(v['totalSeats'] as String),
      registeredCount: 0,
      description: v['description'] as String,
      isPublished: publish,
    );

    await ref.read(activityListProvider.notifier).createActivity(activity);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer une activité')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          initialValue: const {'type': ActivityType.atelier},
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
              FormBuilderDropdown<ActivityType>(
                name: 'type',
                decoration: const mui.InputDecoration(labelText: 'Type'),
                items: ActivityType.values
                    .map(
                      (t) =>
                          mui.DropdownMenuItem(value: t, child: Text(t.label)),
                    )
                    .toList(),
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
                name: 'location',
                decoration: const mui.InputDecoration(labelText: 'Lieu'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'responsibleName',
                decoration: const mui.InputDecoration(labelText: 'Responsable'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'totalSeats',
                decoration: const mui.InputDecoration(
                  labelText: 'Nombre de places',
                ),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Requis'),
                  FormBuilderValidators.numeric(errorText: 'Nombre invalide'),
                ]),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'description',
                decoration: const mui.InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving ? null : () => _save(publish: false),
                      child: const Text('Enregistrer brouillon'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saving ? null : () => _save(publish: true),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Publier'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
