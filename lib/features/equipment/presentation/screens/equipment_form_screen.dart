import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/equipment_entity.dart';
import '../providers/equipment_providers.dart';

/// Ticket: Gp5-4 — add equipment (category, room, state, id, responsible)
class EquipmentFormScreen extends ConsumerStatefulWidget {
  const EquipmentFormScreen({super.key});

  @override
  ConsumerState<EquipmentFormScreen> createState() =>
      _EquipmentFormScreenState();
}

class _EquipmentFormScreenState extends ConsumerState<EquipmentFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() => _saving = true);
    final v = _formKey.currentState!.value;

    final equipment = EquipmentEntity(
      id: const Uuid().v4(),
      inventoryCode: v['inventoryCode'] as String,
      name: v['name'] as String,
      category: v['category'] as EquipmentCategory,
      roomName: v['roomName'] as String,
      state: v['state'] as EquipmentState,
      responsibleName: v['responsibleName'] as String,
    );

    await ref.read(equipmentListProvider.notifier).createEquipment(equipment);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un matériel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          initialValue: const {
            'category': EquipmentCategory.informatique,
            'state': EquipmentState.fonctionnel,
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'inventoryCode',
                decoration: const mui.InputDecoration(
                  labelText: 'Code d\'inventaire',
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'name',
                decoration: const mui.InputDecoration(
                  labelText: 'Nom du matériel',
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDropdown<EquipmentCategory>(
                name: 'category',
                decoration: const mui.InputDecoration(labelText: 'Catégorie'),
                items: EquipmentCategory.values
                    .map(
                      (c) =>
                          mui.DropdownMenuItem(value: c, child: Text(c.label)),
                    )
                    .toList(),
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
              FormBuilderDropdown<EquipmentState>(
                name: 'state',
                decoration: const mui.InputDecoration(labelText: 'État'),
                items: EquipmentState.values
                    .map(
                      (s) =>
                          mui.DropdownMenuItem(value: s, child: Text(s.label)),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderTextField(
                name: 'responsibleName',
                decoration: const mui.InputDecoration(labelText: 'Responsable'),
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
