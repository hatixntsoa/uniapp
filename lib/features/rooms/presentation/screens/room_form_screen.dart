import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/room_entity.dart';
import '../providers/room_providers.dart';

/// Ticket: Gp8-1/8-3 — add/edit room (capacity, type, location, equipment)
class RoomFormScreen extends ConsumerStatefulWidget {
  const RoomFormScreen({super.key});

  @override
  ConsumerState<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends ConsumerState<RoomFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final room = RoomEntity(
      id: const Uuid().v4(),
      name: v['name'] as String,
      capacity: int.parse(v['capacity'] as String),
      type: v['type'] as RoomType,
      location: v['location'] as String,
      equipmentList: (v['equipment'] as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      status: RoomStatus.disponible,
    );

    await ref.read(roomListProvider.notifier).createRoom(room);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une salle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          initialValue: const {'type': RoomType.salleTD},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const mui.InputDecoration(
                  labelText: 'Nom de la salle',
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'capacity',
                decoration: const mui.InputDecoration(labelText: 'Capacité'),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Requis'),
                  FormBuilderValidators.numeric(errorText: 'Nombre invalide'),
                ]),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<RoomType>(
                name: 'type',
                decoration: const mui.InputDecoration(labelText: 'Type'),
                items: RoomType.values
                    .map(
                      (t) =>
                          mui.DropdownMenuItem(value: t, child: Text(t.label)),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'location',
                decoration: const mui.InputDecoration(
                  labelText: 'Localisation',
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'equipment',
                decoration: const mui.InputDecoration(
                  labelText: 'Équipements (séparés par virgule)',
                  hintText: 'ex: Vidéoprojecteur, Micro',
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
