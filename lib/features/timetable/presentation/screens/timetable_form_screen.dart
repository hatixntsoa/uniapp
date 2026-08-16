import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/timetable_slot_entity.dart';
import '../providers/timetable_providers.dart';

/// Ticket: Gp9-1/9-2 — create timetable slot per group/level;
/// assign subject/teacher/room/day/slot
class TimetableFormScreen extends ConsumerStatefulWidget {
  const TimetableFormScreen({super.key});

  @override
  ConsumerState<TimetableFormScreen> createState() =>
      _TimetableFormScreenState();
}

class _TimetableFormScreenState extends ConsumerState<TimetableFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  TimeSlot _parseTime(String v) {
    final parts = v.split(':');
    return TimeSlot(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final slot = TimetableSlotEntity(
      id: const Uuid().v4(),
      subjectName: v['subjectName'] as String,
      teacherName: v['teacherName'] as String,
      roomName: v['roomName'] as String,
      groupName: v['groupName'] as String,
      levelLabel: v['levelLabel'] as String,
      day: v['day'] as Weekday,
      start: _parseTime(v['start'] as String),
      end: _parseTime(v['end'] as String),
    );

    await ref.read(timetableSlotsProvider.notifier).createSlot(slot);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un créneau')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          initialValue: const {'day': Weekday.lundi},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'subjectName',
                decoration: const mui.InputDecoration(labelText: 'Matière'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'teacherName',
                decoration: const mui.InputDecoration(labelText: 'Enseignant'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'roomName',
                decoration: const mui.InputDecoration(labelText: 'Salle'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'groupName',
                      decoration: const mui.InputDecoration(
                        labelText: 'Groupe',
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'Requis',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'levelLabel',
                      decoration: const mui.InputDecoration(
                        labelText: 'Niveau',
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'Requis',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<Weekday>(
                name: 'day',
                decoration: const mui.InputDecoration(labelText: 'Jour'),
                items: Weekday.values
                    .map(
                      (d) =>
                          mui.DropdownMenuItem(value: d, child: Text(d.label)),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'start',
                      decoration: const mui.InputDecoration(
                        labelText: 'Début (HH:mm)',
                        hintText: 'ex: 09:00',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Requis'),
                        FormBuilderValidators.match(
                          RegExp(r'^\d{2}:\d{2}$'),
                          errorText: 'Format HH:mm',
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'end',
                      decoration: const mui.InputDecoration(
                        labelText: 'Fin (HH:mm)',
                        hintText: 'ex: 10:30',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Requis'),
                        FormBuilderValidators.match(
                          RegExp(r'^\d{2}:\d{2}$'),
                          errorText: 'Format HH:mm',
                        ),
                      ]),
                    ),
                  ),
                ],
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
