import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/entities/room_reservation.dart';
import '../providers/room_providers.dart';

/// Ticket: Gp8-5 — reservation with conflict detection
class RoomReservationScreen extends ConsumerStatefulWidget {
  const RoomReservationScreen({super.key, required this.room});

  final RoomEntity room;

  @override
  ConsumerState<RoomReservationScreen> createState() =>
      _RoomReservationScreenState();
}

class _RoomReservationScreenState extends ConsumerState<RoomReservationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;
  String? _conflictMessage;

  Future<void> _reserve() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    setState(() {
      _saving = true;
      _conflictMessage = null;
    });
    final v = _formKey.currentState!.value;
    final start = v['start'] as DateTime;
    final end = v['end'] as DateTime;

    if (!end.isAfter(start)) {
      setState(() {
        _saving = false;
        _conflictMessage = 'L\'heure de fin doit être après l\'heure de début';
      });
      return;
    }

    final error = await ref
        .read(roomReservationsProvider(widget.room.id).notifier)
        .reserveWithConflictCheck(
          RoomReservation(
            id: const Uuid().v4(),
            roomId: widget.room.id,
            title: v['title'] as String,
            groupName: v['groupName'] as String,
            startTime: start,
            endTime: end,
          ),
        );

    setState(() => _saving = false);
    if (error != null) {
      setState(() => _conflictMessage = error);
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Réserver — ${widget.room.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: const mui.InputDecoration(
                  labelText: 'Motif / Cours',
                ),
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
                name: 'start',
                inputType: InputType.both,
                decoration: const mui.InputDecoration(labelText: 'Début'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FormBuilderDateTimePicker(
                name: 'end',
                inputType: InputType.both,
                decoration: const mui.InputDecoration(labelText: 'Fin'),
                validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis',
                ),
              ),
              if (_conflictMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _conflictMessage!,
                  style: const TextStyle(color: AppColors.danger),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _saving ? null : _reserve,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Confirmer la réservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
